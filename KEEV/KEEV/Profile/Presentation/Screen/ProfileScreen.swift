//
//  ProfileScreen.swift
//  KEEV
//
//  Created by Yune Cho on 11/15/24.
//

import SwiftUI

/// 프로필 화면
///
/// 프로필 메인 화면입니다.
///
/// 사용자의 프로필 정보를 보여주는 ProfileTopView와 바이브 목록을 보여주는 ProfileVibeView로 구성되어있습니다.
///
/// - Author: 라움
struct ProfileScreen: View {
    @Injected private var service: any ActivityServiceProtocol
    
    @Environment(AppState.self) private var appState
    
    let userID: Int?
    let isMyProfile: Bool
    let isNavigation: Bool
    
    @State private var userProfile: DetailUserUIO? = nil
    @State private var isFollowing: Bool = false
    @State private var showActionSheet = false
    @State private var navigateToReport: ReportType? = nil
    @State private var showProfileEdit = false
    @State private var profileEditedToast: Toast? = nil
    @State private var selectedVibeViewType: VibeViewType = .list
    @State private var scrollID: ShowProfileHeader? = .show
    
    var body: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .top) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        ProfileImageView(
                            userProfile: userProfile,
                            isMyProfile: isMyProfile
                        )
                        .id(ShowProfileHeader.show)
                        
                        ProfileInfoView(
                            userProfile: userProfile,
                            isMyProfile: isMyProfile,
                            isFollowing: $isFollowing,
                            showProfileEdit: $showProfileEdit
                        )
                        .id(ShowProfileHeader.hide)
                        
                        ProfileLikedEventsView(
                            userID: userID
                        )
                        
                        ProfileVibeView(
                            userID: userID,
                            isMyProfile: isMyProfile,
                            selectedVibeViewType: $selectedVibeViewType
                        )
                    }
                }
                .ignoresSafeArea(edges: .top)
                .scrollTargetLayout()
                .scrollPosition(id: $scrollID, anchor: .top)
                
                if scrollID == .show {
                    ProfileHeader(
                        isNavigation: isNavigation,
                        isMyProfile: isMyProfile,
                        showActionSheet: $showActionSheet
                    )
                }
            }
            .backgroundForKEEV()
            .onAppear {
                if let userID {
                    Task {
                        do {
                            userProfile = try await service.getUserInfo(userID: userID)
                            let followState: FollowState = try await service.checkFollowing(of: userID)
                            isFollowing = followState.toBoolean
                        } catch {
                            appState.presentError(error)
                        }
                    }
                }
            }
            .onChange(of: showProfileEdit) {
                if let userID {
                    Task {
                        do {
                            userProfile = try await service.getUserInfo(userID: userID)
                        } catch {
                            appState.presentError(error)
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showProfileEdit) {
                ProfileEditScreen(userProfile: $userProfile, profileEditedToast: $profileEditedToast)
            }
            .toast(with: $profileEditedToast, for: .seconds(of: 2))
            .actionSheetForKEEV(
                isPresented: $showActionSheet,
                configurations: [
                    KEEVActionSheet.ButtonConfiguration.report(title: "신고하기", action: {
                        if let userID {
                            navigateToReport = .user(userID: userID)
                        }
                        showActionSheet = false
                    })
                ]
            )
            .navigationBarBackButtonHidden()
        }
    }
}

/// 바이브 보기 방식에 대한 열거형
///
/// 바이브 보기 방식에 대한 열거형으로 리스트 방식과 테이블 방식이 있습니다.
///
/// - Author: 라움
enum VibeViewType {
    case list
    case table
}

/// 프로필 스크린의 헤더의 노출 여부를 판단하는 열거형입니다.
///
/// 스크롤의 ID에 사용해서 스크롤 위치에 따라 프로필 스크린의 헤더가 화면에 보이게 할지에 대한 여부를 판단합니다.
///
/// - Author: 라움
enum ShowProfileHeader: String, Hashable {
    case show
    case hide
}

#Preview {
    ProfileScreen(userID: nil, isMyProfile: false, isNavigation: false)
}
