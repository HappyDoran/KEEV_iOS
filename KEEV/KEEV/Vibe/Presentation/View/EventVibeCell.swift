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
    private let likeCheckHandler: (Int, Binding<Bool>) -> Void
    
    init(vibeData: VibeUIO, likeCheckHandler: @escaping (Int, Binding<Bool>) -> Void) {
        self.vibeData = vibeData
        self.likeCheckHandler = likeCheckHandler
    }
    
    @State private var isLiked: Bool = false
    
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
                if !comment.isEmpty {
                    Text(comment)
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                }
            }
            
            HStack(spacing: 12) {
                Text(vibeData.createdDate)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .medium)))
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(isLiked ? "Heart.fill.color" : "Heart.fill") 
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 12)
                    
                    Text(vibeData.likeCount > 99 ? "99+" : "\(vibeData.likeCount)")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                }
                .onAppear {
                    likeCheckHandler(vibeData.id, $isLiked)
                }
                
                HStack(spacing: 4) {
                    Image("Reply.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 12)
                    
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

private extension EventVibeCell {
    func profileImage(url: URL?) -> some View {
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
    
    @ViewBuilder
    func vibeImage(url: URL?) -> some View {
        if let url {
            URLCachedImage(
                url: url
            ) { phase in
                if let image = phase.image { // 이미지를 성공적으로 불러왔을 때
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)

                        .frame(height: 160)
                        .clipped()
                        .contentShape(Rectangle().inset(by: 10))

                } else if phase.error == nil { // 이미지를 불러오는 중일 때
                    ProgressView()
                        .frame(height: 160)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(Color.grayBG700)
                        }
                } else { // 에러가 발생했을 때
                    Image(.posterError)
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .frame(height: 160)
                }
            }
            .mask(RoundedRectangle(cornerRadius: 12))
            .frame(maxWidth: .infinity)
            .frame(height: 160)
        } else {
            Image(.posterError)
                .resizable()
                .frame(height: 160)
        }
    }
}

#Preview {
    EventVibeCell(vibeData: .dummy0) { id, bool in
        
    }
}
