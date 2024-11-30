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
    let vibe: VibeUIO
    
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
            NavigationLink {
                LazyView(VibeDetailScreen(vibe: vibe))
            } label: {
                vibeArea
            }
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
            RoundedRectangle(cornerRadius: 4)
                .frame(width: 48, height: 64)
                .overlay {
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
                    .cornerRadius(4)
                    .clipped()
                }
            
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
    }
    
    var vibeArea: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let imageURL = vibe.imageURLs.first {
                vibeImageArea(imageURL: imageURL, imageCount: vibe.imageURLs.count)
            }
            
            if let comment = vibe.comment {
                Text(comment)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                    .foregroundStyle(.gray300)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 16)
            }
            
            HStack(spacing: 4) {
                Image(systemName: "heart.fill")
                
                Text(vibe.likeCount > 99 ? "99+" : "\(vibe.likeCount)")
                    .padding(.trailing, 8)
                
                Image(systemName: "bubble.middle.bottom.fill")
                
                Text(vibe.replyCount > 99 ? "99+" : "\(vibe.replyCount)")
            }
            .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
            .foregroundStyle(.gray500)
            .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    func vibeImageArea(imageURL: URL?, imageCount: Int) -> some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 12)
                .frame(height: 160)
                .overlay {
                    URLCachedImage(
                        url: imageURL
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
                    .frame(height: 160, alignment: .center)
                    .cornerRadius(12)
                    .clipped()
                }
            
            Circle()
                .frame(width: 24, height: 24)
                .foregroundStyle(.gray200)
                .opacity(0.2)
                .overlay {
                    Text("\(imageCount)")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .regular)))
                        .foregroundStyle(.gray200)
                }
                .padding(12)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    ProfileVibeListCell(vibe: .dummy0)

}
