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
    private let userProfile: DetailUserUIO
    private let isMyProfile: Bool
    @Binding private var showActionSheet: Bool
    
    init(userProfile: DetailUserUIO, isMyProfile: Bool, showActionSheet: Binding<Bool>) {
        self.userProfile = userProfile
        self.isMyProfile = isMyProfile
        self._showActionSheet = showActionSheet
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                AsyncImage(url: userProfile.backgroundImageURL) { phase in
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
                    } else {
                        Color.gray800
                            .frame(height: 202)
                            .overlay {
                                Color.black
                                    .opacity(0.2)
                            }
                    }
                }
                
                Spacer()
            }
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    if isMyProfile {
                        NavigationLink {
                            SettingScreen()
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .figmaFont(PretendardFont.title(style: .sm))
                                .foregroundStyle(.gray100)
                                .padding(.vertical, 8)
                        }
                        .tint(.gray100)
                    } else {
                        Button {
                            showActionSheet = true
                        } label: {
                            Image(systemName: "ellipsis")
                                .figmaFont(PretendardFont.title(style: .sm))
                                .foregroundStyle(.gray100)
                                .padding(.vertical, 8)
                        }
                    }
                }
                .padding(.top, 54)
                
                Spacer()
                
                URLProfileImage(url: userProfile.profileImageURL, size: 96, editable: false, strokeWidth: 3, strokeColor: .gray950)
                    .padding(.bottom, 8)
                
                Text(userProfile.nickname)
                    .figmaFont(PretendardFont.title(style: .md))
                    .foregroundStyle(.gray100)
                    .padding(.bottom, 4)
                
                if userProfile.description!.isEmpty && isMyProfile {
                    Text("한 줄 소개를 입력해주세요.")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .medium)))
                        .foregroundStyle(.gray700)
                } else if !userProfile.description!.isEmpty && isMyProfile {
                    Text(userProfile.description!)
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .medium)))
                        .foregroundStyle(.gray300)
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 300)
        .backgroundForKEEV()
    }
}

#Preview {
    ProfileTopView(userProfile: .dummy4, isMyProfile: true, showActionSheet: .constant(false))
}
