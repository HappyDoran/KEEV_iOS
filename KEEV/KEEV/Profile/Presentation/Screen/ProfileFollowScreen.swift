//
//  ProfileFollowScreen.swift
//  KEEV
//
//  Created by Yune Cho on 4/11/25.
//

import SwiftUI

struct ProfileFollowScreen: View {
    @Injected private var activityService: any ActivityServiceProtocol
    
    @Environment(\.dismiss) private var dismiss
    
    let userID: Int?
    let isMyProfile: Bool
    let userFollowType: UserFollowType
    
    @State private var currentPage = 0
    @State private var totalPages = 1
    private let pageSize = 7
    @State private var users: [UserFollowUIO] = []
    @State private var error: Error? = nil
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(users.indices, id: \.self) { index in
                    ProfileFollowCell(user: users[index]) {
                        Task {
                            users[index] = await userFollowAction(user: users[index])
                        }
                    }
                    .onAppear {
                        if index == users.count - 1 && currentPage < totalPages {
                            Task {
                                await loadFollowList(page: currentPage)
                            }
                        }
                    }
                }
            }
            .padding(16)
        }
        .navigationTitle(userFollowType == .follower ? "팔로워" : "팔로잉")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 24){
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.gray100)
                    }
                }
            }
        }
        .onAppear {
            if (currentPage == 0){
                Task {
                    await loadFollowList(page: currentPage)
                }
            }
        }
        .alertForError($error)
    }
}

private extension ProfileFollowScreen {
    func loadFollowList(page: Int) async {
        guard let userID = userID else { return }
        
        do {
            let response: PaginatedResponse<UserFollowUIO>
            if isMyProfile {
                response = try await activityService.myUserList(type: userFollowType, page: currentPage, size: pageSize)
            } else {
                response = try await activityService.userList(of: userID, type: userFollowType, page: currentPage, size: pageSize)
            }
            users.append(contentsOf: response.contents)
            totalPages = response.totalPages
            currentPage += 1
        } catch let failToLoadEvent {
            error = failToLoadEvent
        }
    }
    
    func userFollowAction(user: UserFollowUIO) async -> UserFollowUIO {
        var updatedUser: UserFollowUIO = user
        
        do {
            if updatedUser.isFollowing {
                let followState: FollowState = try await activityService.unfollow(user.id)
                updatedUser.isFollowing = followState.toBoolean
            } else {
                let followState: FollowState = try await activityService.follow(user.id)
                updatedUser.isFollowing = followState.toBoolean
            }
        } catch let failToFollow {
            error = failToFollow
        }
        
        return updatedUser
    }
}

#Preview {
    ProfileFollowScreen(userID: 1, isMyProfile: true, userFollowType: .follower)
}
