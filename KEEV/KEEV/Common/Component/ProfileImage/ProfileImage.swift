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
/// - `size`: 프로필 이미지 프레임의 가로/세로 크기
/// - `editable`: 프로필 이미지 수정 가능 여부
/// - `strokeWidth` : Stroke가 존재한다면 Stroke의 두께
/// - `strokeColor` : Stroke가 존재한다면 Stroke의 색
///`
/// - Note: editable이 true일 경우 프로필 이미지와 우측 하단에 카메라 이미지를 함께 보여줍니다.
///
/// - Author: Doran, 라움
struct ProfileImage: View {
    private let profileImage: UIImage?
    private let size: CGFloat
    private let editable: Bool
    private let strokeWidth: CGFloat?
    private let strokeColor: Color?
    
    init(profileImage: UIImage?, size: CGFloat, editable: Bool, strokeWidth: CGFloat? = nil, strokeColor: Color? = nil) {
        self.profileImage = profileImage
        self.size = size
        self.editable = editable
        self.strokeWidth = strokeWidth
        self.strokeColor = strokeColor
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if profileImage != nil {
                Image(uiImage: profileImage!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .overlay {
                        if let strokeWidth, let strokeColor {
                            Circle()
                                .inset(by: strokeWidth / 2)
                                .stroke(lineWidth: strokeWidth)
                                .foregroundStyle(strokeColor)
                        }
                    }
            } else {
                ZStack {
                    Circle()
                        .frame(width: size, height: size)
                        .foregroundColor(.gray900)
                    
                    Image("ProfileImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: size * 0.72, height: size * 0.82)
                        .padding(.top, size * 0.185)
                }
                .overlay {
                    if let strokeWidth, let strokeColor {
                        Circle()
                            .inset(by: strokeWidth / 2)
                            .stroke(lineWidth: strokeWidth)
                            .foregroundStyle(strokeColor)
                    }
                }
            }
            
            if editable {
                ProfileImageCamera(size: size)
                    .padding(.all, size * 0.029)
            }
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    ProfileImage(profileImage: UIImage(named: "sample"), size: 140, editable: true, strokeWidth: 4, strokeColor: .brand500)
}
