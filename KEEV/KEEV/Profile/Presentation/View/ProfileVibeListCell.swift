//
//  ProfileVibeListCell.swift
//  KEEV
//
//  Created by Yune Cho on 11/16/24.
//

import SwiftUI

/// 바이브의 표시 방식을 리스트로 선택했을 때 보여지는 각각의 리스트 셀
///
/// 바이브의 표시 방식을 리스트로 선택했을 때 바이브 리스트에서 보여지는 각각의 리스트 셀입니다.
///
/// - Author: 라움
struct ProfileVibeListCell: View {
    @Injected private var vibeService: any VibeServiceProtocol
    
    let vibe: VibeUIO
    @State private var isLiked = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(vibe.createdDate)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .medium)))
                    .foregroundStyle(.gray300)
                
                Spacer()
                
                RatingView(rating: vibe.rating, image: Image(.star))
                    .frame(width: 80, height: 16)
            }
            .padding(.top, 16)
            .padding(.bottom, 12)
            .padding(.horizontal, 16)
            
            NavigationLink {
                LazyView(EventDetailScreen(simpleEvent: vibe.event))
            } label: {
                eventInfoArea
                    .padding(.horizontal, 16)
            }
            
            Divider()
                .padding(.vertical, 16)
            
            vibeArea
                .padding(.bottom, 16)
        }
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.grayBG800)
        }
    }
}

private extension ProfileVibeListCell {
    var eventInfoArea: some View {
        HStack(spacing: 12) {
            URLCachedImage(
                url: vibe.event.posterURL
            ) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else if phase.error == nil {
                    ProgressView()
                } else {
                    Text(phase.error?.localizedDescription ?? "알 수 없는 에러가 발생했습니다.")
                }
            }
            .frame(width: 48, height: 64, alignment: .center)
            .mask(RoundedRectangle(cornerRadius: 4))
            
            VStack(alignment: .leading, spacing: 0) {
                Text(vibe.event.name)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .semibold)))
                    .foregroundStyle(.gray50)
                    .lineLimit(1)
                    .padding(.bottom, 4)
                
                Text("\(vibe.event.startDate) ~ \(vibe.event.endDate)")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                    .foregroundStyle(.gray300)
                    .lineLimit(1)
                    .padding(.bottom, 2)
                
                Text(vibe.event.placeName)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                    .foregroundStyle(.gray300)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var vibeArea: some View {
        VStack(alignment: .leading, spacing: 16) {
            vibeImageArea(vibe.imageURLs)
            
            if let comment = vibe.comment {
                Text(comment)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                    .foregroundStyle(.gray300)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 16)
            }
            
            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Image(isLiked ? "Heart.fill.color" : "Heart.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 12)
                    
                    Text(vibe.likeCount > 99 ? "99+" : "\(vibe.likeCount)")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                }
                .onAppear {
                    checkIfUserLikedVibe()
                }
                
                HStack(spacing: 4) {
                    Image("Reply.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 12)
                    
                    Text(vibe.replyCount > 99 ? "99+" : "\(vibe.replyCount)")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                }
                
                Spacer()
            }
            .foregroundStyle(.gray500)
            .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    func vibeImageArea(_ vibeImages: [URL?]) -> some View {
        if let thumbnailURL = vibeImages.first {
            URLCachedImage(
                url: thumbnailURL
            ) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 160, alignment: .center)
                        .clipped()
                        .contentShape(Rectangle())
                } else if phase.error == nil {
                    ProgressView()
                } else {
                    Image(.posterError)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 160, alignment: .center)
                        .clipped()
                        .contentShape(Rectangle())
                }
            }
            .mask(RoundedRectangle(cornerRadius: 12))
            .overlay(alignment: .bottomTrailing) {
                Circle()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.gray200)
                    .opacity(0.2)
                    .overlay {
                        Text("\(vibeImages.count)")
                            .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .regular)))
                            .foregroundStyle(.gray200)
                    }
                    .padding(12)
            }
            .padding(.horizontal, 16)
        } else {
            EmptyView()
        }
    }
}

private extension ProfileVibeListCell {
    func checkIfUserLikedVibe() {
        Task {
            do {
                isLiked = try await vibeService.checkIfUserLikedVibe(vibeID: vibe.id)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    NavigationStack {
        NavigationLink {
            LazyView(VibeDetailScreen(vibe: .dummy0))
        } label: {
            ProfileVibeListCell(vibe: .dummy7)
        }
    }
}
