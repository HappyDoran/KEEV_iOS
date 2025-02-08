//
//  EventVibeCell.swift
//  KEEV
//
//  Created by Doran on 11/18/24.
//

import SwiftUI

/// 바이브의 내용을 보여주는 셀뷰
///
/// - Parameter vibeData: 셀에 표시할 바이브 데이터 객체입니다.
///
/// - Author: Doran
struct EventVibeCell: View {
    private let vibeData: VibeUIO
    
    init(vibeData: VibeUIO) {
        self.vibeData = vibeData
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing : 0){
            HStack {
                Text(vibeData.createdDate)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .medium)))
                    .foregroundStyle(.gray300)
                
                Spacer()
                
                RatingView(rating: vibeData.rating, image: Image(.star))
                    .frame(width: 80, height: 16)
            }
            .padding(.top, 16)
            .padding(.bottom, 12)
            .padding(.horizontal, 16)
            
            NavigationLink {
                LazyView(EventDetailScreen(simpleEvent: vibeData.event))
            } label: {
                eventInfo
                    .padding(.horizontal, 16)
            }
            
            Rectangle().fill(Color.grayBG700).frame(height: 1)
                .padding(.top, 16)
        
            vibe.padding(.bottom, 16)
        }
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.grayBG800)
        }
        .padding(.bottom, 20)
    }
}

private extension EventVibeCell {
    var eventInfo: some View {
        HStack(spacing: 12) {
            URLCachedImage(
                url: vibeData.event.posterURL
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
                Text(vibeData.event.name)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .semibold)))
                    .foregroundStyle(.gray50)
                    .lineLimit(1)
                    .padding(.bottom, 4)
                
                Text("\(vibeData.event.startDate) ~ \(vibeData.event.endDate)")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                    .foregroundStyle(.gray300)
                    .lineLimit(1)
                    .padding(.bottom, 2)
                
                Text(vibeData.event.placeName)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                    .foregroundStyle(.gray300)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var vibe: some View {
        VStack(alignment: .leading, spacing: 16) {
            vibeImage(vibeData.imageURLs)
            
            if let comment = vibeData.comment {
                Text(comment)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                    .foregroundStyle(.gray300)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 16)
            }
            
            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Image(vibeData.isLiked ? "Heart.fill.color" : "Heart.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 12)
                    
                    Text(vibeData.likeCount > 99 ? "99+" : "\(vibeData.likeCount)")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                }
                
                HStack(spacing: 4) {
                    Image("Reply.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 12)
                    
                    Text(vibeData.replyCount > 99 ? "99+" : "\(vibeData.replyCount)")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                }
                
                Spacer()
            }
            .foregroundStyle(.gray500)
            .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    func vibeImage(_ vibeImages: [URL?]) -> some View {
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

#Preview {
    EventVibeCell(vibeData: .dummy0)
}
