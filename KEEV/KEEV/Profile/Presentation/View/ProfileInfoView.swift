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
    private let userProfile: DetailUserUIO?
    private let isMyProfile: Bool
    
    init(userProfile: DetailUserUIO?, isMyProfile: Bool) {
        self.userProfile = userProfile
        self.isMyProfile = isMyProfile
    }
    
    var body: some View {
        VStack {
            Text(userProfile?.nickname ?? "게스트")
                .figmaFont(PretendardFont.title(style: .md))
                .foregroundStyle(.gray100)
                .padding(.bottom, 8)
        }
    }
}

private extension ProfileInfoView {
    @ViewBuilder
    var descriptionImageView: some View {
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

#Preview {
    ProfileInfoView(userProfile: .dummy0, isMyProfile: true)
}
