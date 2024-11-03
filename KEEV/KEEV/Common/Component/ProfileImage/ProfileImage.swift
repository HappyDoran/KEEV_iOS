//
//  ProfileImage.swift
//  KEEV
//
//  Created by Doran on 10/28/24.
//

import SwiftUI

/// 프로필 이미지를 보여주는 뷰
///
/// - `profileImage`: 프로필 이미지
/// - `editable`: 프로필 이미지 수정 가능 여부
///`
/// - Note: editable이 true일 경우 프로필 이미지와 우측 하단에 카메라 이미지를 함께 보여줍니다.
///
/// - Author: Doran, 라움
struct ProfileImage: View {
    private let profileImage: UIImage?
    private let editable: Bool
    
    init(profileImage: UIImage?, editable: Bool) {
        self.profileImage = profileImage
        self.editable = editable
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if profileImage != nil {
                Image(uiImage: profileImage!)
                    .resizable()
                    .frame(width: 140, height: 140)
                    .scaledToFit()
                    .clipShape(Circle())
            } else {
                ZStack {
                    Circle()
                        .frame(width: 140,height: 140)
                        .foregroundColor(.gray900)
                    
                    Image("ProfileImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 101.12,height: 114.5)
                        .padding(.top, 25.9)
                }
            }
            
            if editable {
                ProfileImageCamera()
                    .padding(.all, 2)
            }
        }
        .frame(width: 140, height: 140)
    }
}

#Preview {
    ProfileImage(profileImage: UIImage(named: "sample"), editable: true)
}
