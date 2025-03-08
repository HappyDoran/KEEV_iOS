//
//  ProfileImageView.swift
//  KEEV
//
//  Created by Yune Cho on 11/15/24.
//

import SwiftUI

/// 프로필 화면 상단 프로필 사진 영역
///
/// 프로필 화면 상단 영역에 표시되는 프로필 사진 영역이며 다음과 같은 정보가 표시됩니다.
///
/// - 프로필 사진, 배경사진
///
/// - Author: 라움
struct ProfileImageView: View {
    private let userProfile: DetailUserUIO?
    private let isMyProfile: Bool
    
    init(userProfile: DetailUserUIO?, isMyProfile: Bool) {
        self.userProfile = userProfile
        self.isMyProfile = isMyProfile
    }
    
    var body: some View {
        ZStack {
            backgroundImageView
            
            VStack(spacing: 0) {
                Spacer()
                
                URLProfileImage(url: userProfile?.profileImageURL, size: 96, editable: false, strokeWidth: 3, strokeColor: .gray950)
                    .padding(.bottom, 8)
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 255)
        .backgroundForKEEV()
    }
}

private extension ProfileImageView {
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
}

#Preview {
    ProfileImageView(userProfile: .dummy0, isMyProfile: true)
}
