//
//  EventVibeCell.swift
//  KEEV
//
//  Created by Doran on 11/18/24.
//

import SwiftUI

struct EventVibeCell: View {
    private let vibeData: VibeUIO
    
    init(vibeData: VibeUIO) {
        self.vibeData = vibeData
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundColor(.grayBG800)
            .overlay{
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
                    }
                    .padding(.horizontal, 16)
                    
                    Rectangle().fill(Color.grayBG700).frame(height: 1)
                        .padding(.top, 16)
                    
                    if let firstImageURL = vibeData.imageURLs.first {
                        vibeImage(url: firstImageURL)
                            .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                    }
                    
                    if let comment = vibeData.comment {
                        Text("\(comment)")
                            .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                            .lineLimit(2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                    }
                    
                    HStack(spacing: 12) {
                        Text("\(vibeData.createdDate)")
                            .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .medium)))
                            .foregroundColor(.gray500)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "heart.fill")
                                .frame(width: 18, height: 18)
                                .foregroundColor(.gray500)
                            Text("\(vibeData.likeCount)")
                                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                                .foregroundColor(.gray500)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "bubble.middle.bottom.fill")
                                .frame(width: 18, height: 18)
                                .foregroundColor(.gray500)
                            Text("\(vibeData.replyCount)")
                                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                                .foregroundColor(.gray500)
                        }
                    }
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                    
                    
                }
            }
            .frame(height: calculateHeight(for: vibeData))
            .padding(.bottom, 20)
    }
}

extension EventVibeCell {
    private func profileImage(url: URL?) -> some View {
        ZStack {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray900)
            
            URLCachedImage(
                url: url
            ) { phase in
                if let image = phase.image { // 이미지를 성공적으로 불러왔을 때
                    image
                        .resizable()
                        .clipShape(Circle())
                } else if phase.error == nil { // 이미지를 불러오는 중일 때
                    ProgressView()
                } else { // 에러가 발생했을 때
                    Text(phase.error?.localizedDescription ?? "알 수 없는 에러가 발생했습니다.")
                }
            }
            .frame(width: 40, height: 40, alignment: .center)
        }
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
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else if phase.error == nil { // 이미지를 불러오는 중일 때
                    ProgressView()
                } else { // 에러가 발생했을 때
                    Text(phase.error?.localizedDescription ?? "알 수 없는 에러가 발생했습니다.")
                }
            }
            .frame(height: 160, alignment: .center)
        }
    }
    
    private func calculateHeight(for vibe: VibeUIO) -> CGFloat {
        // 이미지 높이
        let imageHeight: CGFloat = vibe.imageURLs.first != nil || vibe.imageURLs.count != 0 ? 176 : 0
        // 텍스트 높이 (예시로 고정값 사용, 필요에 따라 조정)
        let commentHeight: CGFloat = vibe.comment != nil ? 58 : 0
        // 기타 높이
        let headerHeight: CGFloat = 72 // 프로필과 제목 높이
        let footerHeight: CGFloat = 50 // 날짜 및 버튼 높이
        
        print(headerHeight + imageHeight + commentHeight + footerHeight)
        
        return headerHeight + imageHeight + commentHeight + footerHeight
    }
}

#Preview {
    EventVibeCell(vibeData: .dummy2)
}
