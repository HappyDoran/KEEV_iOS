//
//  VibeFeedCell.swift
//  KEEV
//
//  Created by Doran on 2/9/25.
//

import SwiftUI

struct VibeFeedCell: View {
    private let vibeData: VibeUIO
    
    init(vibeData: VibeUIO) {
        self.vibeData = vibeData
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing : 12){
            profileHeader
            
            NavigationLink {
                LazyView(EventDetailScreen(simpleEvent: vibeData.event))
            } label: {
                VibeFeedEventInfoCell(eventData: vibeData.event)
            }
        
            vibe
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.grayBG800)
        }
    }
}

private extension VibeFeedCell {
    var profileHeader: some View {
        HStack(spacing: 8) {
            URLCircleImage(url: vibeData.userProfileImageURL)
                .frame(width: 36, height: 36)
            
            Text(vibeData.userNickname)
                .figmaFont(
                    PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .semibold))
                )
                .foregroundStyle(.gray50)
            
            Spacer()
            
            RatingView(rating: vibeData.rating, image: Image(.star))
                .frame(width: 80, height: 16)
        }
    }
    
    var vibe: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let comment = vibeData.comment {
                Text(comment)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                    .foregroundStyle(.gray300)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            
            vibeImage(vibeData.imageURLs)
            
            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Rectangle()
                        .fill(.gray700)
                        .mask {
                            Image("Heart.fill")
                        }
                        .frame(width: 13.5, height: 12)
                    
                    Text(vibeData.likeCount > 99 ? "99+" : "\(vibeData.likeCount)")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                }
                
                HStack(spacing: 4) {
                    Rectangle()
                        .fill(.gray700)
                        .mask {
                            Image("Reply.fill")
                        }
                        .frame(width: 13.5, height: 12)
                    
                    Text(vibeData.replyCount > 99 ? "99+" : "\(vibeData.replyCount)")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                }
                
                Spacer()
                
                Text(vibeData.createdDate)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .medium)))
            }
            .foregroundStyle(.gray700)
        }
    }
    
    @ViewBuilder
    func vibeImage(_ vibeImages: [URL?]) -> some View {
        if let thumbnailURL = vibeImages.first {
            VibeThumbnailImage(thumbnailURL: thumbnailURL)
                .addImageCount(vibeImages.count)
        } else {
            EmptyView()
        }
    }
}

#Preview{
    VibeFeedCell(vibeData: .dummy0)
}
