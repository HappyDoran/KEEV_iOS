//
//  RatingView.swift
//  KEEV
//
//  Created by Yune Cho on 11/17/24.
//

import SwiftUI

/// 바이브에서 별점을 표시해주는 뷰
///
/// 바이브에서 이벤트의 별점을 표시해주는 뷰입니다.
///
/// 사용예시는 아래와 같습니다.
///
/// ```swift
/// RatingView(rating: vibe.rating, image: Image(.star))
/// ```
///
/// - Author: 라움
struct RatingView: View {
    private let rating: Double
    private let image: Image
    
    init(rating: Double, image: Image) {
        self.rating = rating
        self.image = image
    }
    
    private let maxRating = 5.0
    
    var body: some View {
        let stars = HStack(spacing: 3) {
            ForEach(0..<Int(maxRating), id: \.self) { index in
                Color.grayBG700
                    .mask {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
            }
        }
        
        stars.overlay(
            GeometryReader { geometry in
                Rectangle()
                    .foregroundStyle(.grayBG300)
                    .frame(width: rating / maxRating * geometry.size.width)
            }
        )
        .mask(stars)
    }
}

#Preview {
    RatingView(rating: 3.5, image: Image(.star))
}
