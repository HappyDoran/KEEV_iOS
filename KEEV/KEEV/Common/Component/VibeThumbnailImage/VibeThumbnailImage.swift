//
//  VibeThumbnailImage.swift
//  KEEV
//
//  Created by 김준성 on 2/10/25.
//

import SwiftUI

/// 바이브 썸네일로 쓰이는 뷰
///
/// - Note: 구조체 내의 메소드 `addImageCount`를 통해 이미지의 개수도 오버레이할 수 있습니다.
/// - Author: newJunsung
struct VibeThumbnailImage: View {
    let thumbnailURL: URL?
    
    var body: some View {
        URLCachedImage(
            url: thumbnailURL
        ) { phase in
            if let image = phase.image {
                image
                    .cropToRectangle()
            } else if phase.error == nil {
                Rectangle()
                    .fill(Color.grayBG700)
                    .overlay {
                        ProgressView()
                    }
                    .frame(height: 160)
                
            } else {
                Image(.posterError)
                    .cropToRectangle()
            }
        }
        .mask(RoundedRectangle(cornerRadius: 12))
    }
}

extension VibeThumbnailImage {
    /// 바이브 썸네일에 바이브 개수를 출력하는 함수
    ///
    /// - Parameters:
    ///   - count: 이미지의 개수
    ///
    /// - Author: newJunsung
    func addImageCount(_ count: Int) -> some View {
        overlay(alignment: .bottomTrailing) {
            Circle()
                .frame(width: 24, height: 24)
                .foregroundStyle(.gray200)
                .opacity(0.2)
                .overlay {
                    Text("\(count)")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .regular)))
                        .foregroundStyle(.gray200)
                }
                .padding(12)
        }
    }
}

#Preview {
    VibeThumbnailImage(thumbnailURL: VibeUIO.dummy0.imageURLs.first!)
}
