//
//  URLProfileImage.swift
//  KEEV
//
//  Created by 김준성 on 11/27/24.
//

import SwiftUI

/// 프로필 이미지를 보여주는 뷰
///
/// `ProfileImage`와 다르게 `URL`을 매개변수로 받습니다.
///
/// - `url`: 프로필 이미지의 URL
/// - `size`: 프로필 이미지 프레임의 가로/세로 크기
/// - `editable`: 프로필 이미지 수정 가능 여부
/// - `strokeWidth` : Stroke가 존재한다면 Stroke의 두께
/// - `strokeColor` : Stroke가 존재한다면 Stroke의 색
///`
/// - Note: `editable`이 `true`일 경우 프로필 이미지와 우측 하단에 카메라 이미지를 함께 보여줍니다. `URLCachedImage`를 활용하여 캐싱된 이미지를 보여줍니다.
///
/// - Author: newJunsung
struct URLProfileImage: View {
    private let url: URL?
    private let size: CGFloat
    private let editable: Bool
    private let strokeWidth: CGFloat?
    private let strokeColor: Color?
    
    init(url: URL?, size: CGFloat, editable: Bool, strokeWidth: CGFloat? = nil, strokeColor: Color? = nil) {
        self.url = url
        self.size = size
        self.editable = editable
        self.strokeWidth = strokeWidth
        self.strokeColor = strokeColor
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if let url {
                URLCachedImage(url: url) { phase in
                    if let image = phase.image {
                        image
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
                    } else if phase.error != nil {
                        Image(systemName: "xmark.circle.fill")
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
                        ProgressView()
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
