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
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(vibe.createdDate)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .medium)))
                    .foregroundStyle(.gray300)
                
                Spacer()
                
                RatingView(rating: vibe.rating, image: Image(.star))
                    .frame(height: 16)
            }
            .padding(.top, 16)
            .padding(.bottom, 12)
            .padding(.horizontal, 16)
            
            NavigationLink {
                //공연 상세로 이동해야합니다.
            } label: {
                eventInfoArea
                    .padding(.horizontal, 16)
            }
            
            Divider()
                .padding(.vertical, 16)
            
            if let imageURL = vibe.imageURLs.first {
                NavigationLink {
                    //바이브 상세로 이동해야합니다.
                } label: {
                    vibeImageArea(imageURL: imageURL, imageCount: vibe.imageURLs.count)
                        .padding(.bottom, 16)
                }
            }
            
            if let comment = vibe.comment {
                NavigationLink {
                    
                } label: {
                    vibeCommentArea(comment: comment)
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                }
            }
            
            NavigationLink {
                //바이브 상세로 이동해야합니다.
            } label: {
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
        }
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.grayBG700)
        }
    }
}

extension ProfileVibeListCell {
    private var eventInfoArea: some View {
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
    
    @ViewBuilder
    private func vibeImageArea(imageURL: URL?, imageCount: Int) -> some View {
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
    
    @ViewBuilder
    private func vibeCommentArea(comment: String) -> some View {
        if comment.count <= 55 {
            Text(comment)
                .foregroundStyle(.gray300)
        } else {
            Text(comment.prefix(55) + "... ")
                .foregroundStyle(.gray300)
            +
            Text("더보기")
                .foregroundStyle(.gray50)
        }
    }
}

#Preview {
    ProfileVibeListCell(vibe: VibeUIO.dummy5)
}
