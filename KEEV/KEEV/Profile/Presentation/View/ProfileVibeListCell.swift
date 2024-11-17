//
//  ProfileVibeListCell.swift
//  KEEV
//
//  Created by Yune Cho on 11/16/24.
//

import SwiftUI

struct ProfileVibeListCell: View {
    private let vibe: VibeUIO
    
    init(vibe: VibeUIO) {
        self.vibe = vibe
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(vibe.createdDate)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .medium)))
                    .foregroundStyle(.gray300)
                
                Spacer()
                
                Text("\(vibe.rating)")
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
            
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 48, height: 64)
                    .overlay {
                        AsyncImage(url: vibe.event.posterURL) { result in
                            result.image?
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 48, height: 64)
                                .cornerRadius(4)
                                .clipped()
                        }
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
            .padding(.horizontal, 16)
            
            Divider()
            
            if let imageURL = vibe.imageURLs.first {
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 160)
                    .overlay {
                        AsyncImage(url: imageURL) { result in
                            result.image?
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 160)
                                .cornerRadius(12)
                                .clipped()
                        }
                    }
                    .padding(.horizontal, 16)
            }
            
            if let comment = vibe.comment {
                Text(comment)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                    .foregroundStyle(.gray300)
                    .lineLimit(2)
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
            .padding(.bottom, 16)
        }
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.gray800)
        }
    }
}

#Preview {
    ProfileVibeListCell(vibe: VibeUIO.dummy0)
}
