//
//  ProfileFollowCell.swift
//  KEEV
//
//  Created by Yune Cho on 4/11/25.
//

import SwiftUI

/// 팔로워/팔로잉 목록에서 각 유저 정보에 대한 Cell
///
/// 팔로워/팔로잉 목록 스크린에 보여지는 각 유저들에 대한 Cell입니다.
///
/// - Author: 라움
struct ProfileFollowCell: LoginCheckableView {
    @Environment(AppState.self) var appState
    
    let user: UserFollowUIO
    let userFollowAction: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            URLProfileImage(url: user.profileImageURL, size: 56, editable: false, strokeWidth: 0.75, strokeColor: .white.opacity(0.1))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.nickname)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .semibold)))
                    .foregroundStyle(.gray100)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Text("바이브")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                    
                    Text("\(user.vibeCount)")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                    
                    Text("•")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                    
                    Text("관심공연")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                    
                    Text("\(user.interestedEventCount)")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                        
                }
                .foregroundStyle(.gray500)
            }
            
            Spacer()
            
            FollowButton(isFollowing: user.isFollowing) {
                checkLoginBefore {
                    userFollowAction()
                }
            }
        }
    }
}

#Preview {
    ProfileFollowCell(user: UserFollowUIO.dummy3, userFollowAction: {})
}
