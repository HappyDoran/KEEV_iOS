//
//  ProfileImageCamera.swift
//  KEEV
//
//  Created by Doran on 10/28/24.
//

import SwiftUI

/// 프로필 수정 화면에 들어가는 작은 카메라 모양 아이콘
///
/// - `size`: 프로필 이미지 프레임의 가로/세로 크기
///
/// - ProfileImage에 때려박지 않은 이유는 해당 아이콘은 프로필을 수정할 때에만 사용하는 Element이기 때문에 따로 빼서 사용하는 것이 좋다고 생각했습니다.
///
/// - Author: Doran, 라움
struct ProfileImageCamera: View {
    private let size: CGFloat
    
    init(size: CGFloat) {
        self.size = size
    }
    
    var body: some View {
        Circle()
            .frame(width: size * 0.24, height: size * 0.24)
            .foregroundColor(.brand500)
            .overlay{
                Image(systemName: "camera.fill")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .medium)))
                    .foregroundColor(.gray50)
            }
    }
}

#Preview {
    ProfileImageCamera(size: 140)
}
