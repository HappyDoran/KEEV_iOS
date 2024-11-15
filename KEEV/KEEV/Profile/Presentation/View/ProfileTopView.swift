//
//  ProfileTopView.swift
//  KEEV
//
//  Created by Yune Cho on 11/15/24.
//

import SwiftUI

struct ProfileTopView: View {
    private let userProfile: UserProfile
    @Binding private var showSetting: Bool
    
    init(userProfile: UserProfile, showSetting: Binding<Bool>) {
        self.userProfile = userProfile
        self._showSetting = showSetting
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if let backgroundImage = userProfile.backgroundImage {
                    Image(uiImage: backgroundImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 202)
                        .clipped()
                        .overlay(content: {
                            Color.black
                                .opacity(0.2)
                        })
                } else {
                    Color.gray800
                        .frame(height: 202)
                        .overlay(content: {
                            Color.black
                                .opacity(0.2)
                        })
                }
                
                Spacer()
            }
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    NavigationLink {
                        SettingScreen()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.gray100)
                            .padding(.vertical, 8)
                    }
                }
                .padding(.top, 54)
                
                Spacer()
                
                ProfileImage(profileImage: userProfile.profileImage, size: 96, editable: false, strokeWidth: 3, strokeColor: .gray950)
                    .padding(.bottom, 8)
                
                Text(userProfile.nickname)
                    .figmaFont(PretendardFont.title(style: .md))
                    .foregroundStyle(.gray100)
                    .padding(.bottom, 4)
                
                if userProfile.description.isEmpty {
                    Text("한 줄 소개를 입력해주세요.")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .medium)))
                        .foregroundStyle(.gray700)
                } else {
                    Text(userProfile.description)
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
    ProfileTopView(
        userProfile: UserProfile(nickname: "가래떡강아지", description: "나는 바보입니다"),
        showSetting: .constant(false)
    )
}
