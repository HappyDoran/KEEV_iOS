//
//  ProfileTopView.swift
//  KEEV
//
//  Created by Yune Cho on 11/15/24.
//

import SwiftUI

/// 프로필 화면 상단 프로필 정보 영역
///
/// 프로필 화면 상단 영역에 표시되는 프로필 정보 영역이며 다음과 같은 정보가 표시됩니다.
///
/// - 프로필 사진, 닉네임, 한 줄 소개, 배경사진
///
/// - Author: 라움
struct ProfileTopView: View {
    private let userProfile: DetailUserUIO?
    private let isMyProfile: Bool
    @Binding private var showActionSheet: Bool
    @Binding private var navigateToReport: ReportType?
    
    init(
        userProfile: DetailUserUIO?,
        isMyProfile: Bool,
        showActionSheet: Binding<Bool>,
        navigateToReport: Binding<ReportType?>
    ) {
        self.userProfile = userProfile
        self.isMyProfile = isMyProfile
        self._showActionSheet = showActionSheet
        self._navigateToReport = navigateToReport
    }
    
    var body: some View {
        ZStack {
            backgroundImageView
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    if isMyProfile {
                        NavigationLink {
                            SettingScreen()
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .figmaFont(PretendardFont.body(style: .init(bodySize: .xlarge, bodyWeight: .semibold)))
                                .font(.system(size: 20))
                                .foregroundStyle(.gray100)
                                .padding(.vertical, 8)
                                .frame(height: 48)
                        }
                        .tint(.gray100)
                    }
                }
                .padding(.top, 54)
                
                Spacer()
                
                URLProfileImage(url: userProfile?.profileImageURL, size: 96, editable: false, strokeWidth: 3, strokeColor: .gray950)
                    .padding(.bottom, 8)
                
                Text(userProfile?.nickname ?? "게스트")
                    .figmaFont(PretendardFont.title(style: .md))
                    .foregroundStyle(.gray100)
                    .padding(.bottom, 8)
                
                descriptionImageView
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 300)
        .backgroundForKEEV()
    }
}

private extension ProfileTopView {
    var backgroundImageView: some View {
        VStack(spacing: 0) {
            if let backgroundImageURL = userProfile?.backgroundImageURL {
                AsyncImage(url: backgroundImageURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 202)
                            .clipped()
                            .overlay {
                                Color.black
                                    .opacity(0.2)
                            }
                    } else if phase.error == nil {
                        ProgressView()
                            .frame(height: 202)
                            .overlay {
                                Color.black
                                    .opacity(0.2)
                            }
                    } else { // 에러가 났을 때의 뷰
                        emptyBackgroundImageView
                    }
                }
            } else { // 유저가 `nil`이거나 배경화면이 없을 때의 뷰
                emptyBackgroundImageView
            }
            Spacer()
        }
    }
    
    var emptyBackgroundImageView: some View {
        Color.gray800
            .frame(height: 202)
            .overlay {
                Color.black
                    .opacity(0.2)
            }
    }
    
    @ViewBuilder
    var descriptionImageView: some View {
        if let description = userProfile?.description {
            if description.isEmpty && isMyProfile {
                Text("한 줄 소개를 입력해주세요.")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                    .foregroundStyle(.gray700)
            } else if description.isEmpty && isMyProfile {
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

#Preview {
    ProfileTopView(userProfile: .dummy0, isMyProfile: true, showActionSheet: .constant(false), navigateToReport: .constant(nil))
}
