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
                eventInfo
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
        } else {
            EmptyView()
        }
    }
}

#Preview{
    VibeFeedCell(vibeData: .dummy0)
}
