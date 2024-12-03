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
            HStack(spacing: 0){
                profileImage(url: vibeData.userProfileImageURL)
                
                Text("\(vibeData.userNickname)")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .semibold)))
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .padding(.leading, 16)
                
                Spacer()
                
                //라움이 만든 프로필의 바이브 별점 가져다 쓰기
                RatingView(rating: vibeData.rating, image: Image(.star))
                    .frame(width: 80, height: 16)
            }
            .padding(.horizontal, 16)
            
            Rectangle().fill(Color.grayBG700).frame(height: 1)
                .padding(.top, 16)
            
            if let firstImageURL = vibeData.imageURLs.first {
                vibeImage(url: firstImageURL)
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
            }
            
            if let comment = vibeData.comment {
                Text(comment)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
            }
            
            HStack(spacing: 12) {
                Text(vibeData.createdDate)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .medium)))
                
                Spacer()
                
//                HStack(spacing: 4) {
//                    Image(.heartFill)
//                    
//                    Text(vibeData.likeCount > 99 ? "99+" : "\(vibeData.likeCount)")
//                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
//                }
                
                HStack(spacing: 4) {
                    Image(.replyFill)

                    Text(vibeData.replyCount > 99 ? "99+" : "\(vibeData.replyCount)")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                }
            }
            .foregroundColor(.gray500)
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
            
            
        }
        .padding(.vertical, 16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.grayBG800)
        }
        .padding(.bottom, 20)
    }
}

extension EventVibeCell {
    private func profileImage(url: URL?) -> some View {
        URLCachedImage(
            url: url
        ) { phase in
            if let image = phase.image { // 이미지를 성공적으로 불러왔을 때
                image
                    .resizable()
            } else if phase.error == nil { // 이미지를 불러오는 중일 때
                ProgressView()
            } else { // 에러가 발생했을 때
                Image("ProfileImage")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
        }
        .mask {
            Circle()
                .frame(width: 40, height: 40)
        }
        .frame(width: 40, height: 40, alignment: .center)
    }
    
    private func vibeImage(url: URL?) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(height: 160)
                .foregroundColor(.gray900)
            
            URLCachedImage(
                url: url
            ) { phase in
                if let image = phase.image { // 이미지를 성공적으로 불러왔을 때
                    image
                        .resizable()
                        .mask(
                            RoundedRectangle(cornerRadius: 12)
                        )
                } else if phase.error == nil { // 이미지를 불러오는 중일 때
                    ProgressView()
                } else { // 에러가 발생했을 때
                    Text(phase.error?.localizedDescription ?? "알 수 없는 에러가 발생했습니다.")
                }
            }
            .frame(height: 160)
        }
    }
}

#Preview {
    EventVibeCell(vibeData: .dummy0)
}
