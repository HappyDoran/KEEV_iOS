//
//  ProfileInfoView.swift
//  KEEV
//
//  Created by Yune Cho on 3/8/25.
//

import SwiftUI

/// 프로필 화면 상단 프로필 정보 영역
///
/// 프로필 화면 상단 영역에 표시되는 프로필 정보 영역이며 다음과 같은 정보가 표시됩니다.
///
/// - 닉네임, 프로필 수정/팔로우/팔로잉 버튼, 팔로우, 팔로잉, 한 줄 소개
///
/// - Author: 라움
struct ProfileInfoView: View {
    @Injected private var activityService: any ActivityServiceProtocol
    
    private let userProfile: DetailUserUIO?
    private let isMyProfile: Bool
    @Binding private var isFollowing: Bool
    @Binding private var showProfileEdit: Bool
    
    init(userProfile: DetailUserUIO?, isMyProfile: Bool, isFollowing: Binding<Bool>, showProfileEdit: Binding<Bool>) {
        self.userProfile = userProfile
        self.isMyProfile = isMyProfile
        self._isFollowing = isFollowing
        self._showProfileEdit = showProfileEdit
    }
    
    @State private var tapFeedback = false
    @State private var error: Error? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                userNicknameArea
                
                Spacer()
                
                if isMyProfile {
                    profileEditButton
                } else {
                    FollowButton(isFollowing: isFollowing) {
                        Task {
                            if let userProfile = userProfile {
                                await userFollowAction(user: userProfile)
                            }
                        }
                    }
                }
            }
            
            followInfoArea
            
            profileDescriptionArea
        }
        .backgroundForKEEV()
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .sensoryFeedback(.impact, trigger: tapFeedback)    }
}

private extension ProfileInfoView {
    var userNicknameArea: some View {
        Text(userProfile?.nickname ?? "게스트")
            .figmaFont(PretendardFont.title(style: .md))
            .bold()
            .foregroundStyle(.gray100)
    }
    
    var profileEditButton: some View {
        Button {
            tapFeedback.toggle()
            showProfileEdit = true
        } label: {
            RoundedRectangle(cornerRadius: 50)
                .frame(width: 50, height: 29)
                .foregroundStyle(.grayBG700)
                .overlay {
                    Text("수정")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .semibold)))
                        .foregroundStyle(.gray300)
                }
        }
    }
    
    var followInfoArea: some View {
        HStack(spacing: 8) {
            HStack(spacing: 6) {
                Text("팔로우")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                    .foregroundStyle(.gray500)
                
                NavigationLink {
                    ProfileFollowScreen(userID: userProfile?.id, isMyProfile: isMyProfile, userFollowType: .follower)
                } label: {
                    Text("\(userProfile?.followerCount ?? 0)")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                        .foregroundStyle(.gray50)
                }
            }
            
            Text("•")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                .foregroundStyle(.gray500)
            
            HStack(spacing: 6) {
                Text("팔로잉")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                    .foregroundStyle(.gray500)
                
                NavigationLink {
                    ProfileFollowScreen(userID: userProfile?.id, isMyProfile: isMyProfile, userFollowType: .following)
                } label: {
                    Text("\(userProfile?.followingCount ?? 0)")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                        .foregroundStyle(.gray50)
                }
            }
        }
    }
    
    @ViewBuilder
    var profileDescriptionArea: some View {
        if let description = userProfile?.description {
            if description.isEmpty && isMyProfile {
                Text("한 줄 소개를 입력해주세요.")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                    .foregroundStyle(.gray700)
            } else if !description.isEmpty && isMyProfile {
                Text(description)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                    .foregroundStyle(.gray300)
            }
        } else {
            if isMyProfile {
                Text("한 줄 소개를 입력해주세요.")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                    .foregroundStyle(.gray700)
            }
        }
    }
}

private extension ProfileInfoView {
    func userFollowAction(user: DetailUserUIO) async {
        do {
            if isFollowing {
                let followState: FollowState = try await activityService.unfollow(user.id)
                isFollowing = followState.toBoolean
            } else {
                let followState: FollowState = try await activityService.follow(user.id)
                isFollowing = followState.toBoolean
            }
        } catch let failToFollow {
            error = failToFollow
        }
    }
}

#Preview {
    ProfileInfoView(userProfile: .dummy0, isMyProfile: true, isFollowing: .constant(false), showProfileEdit: .constant(true))
}
