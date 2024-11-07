//
//  VibeRatingCell.swift
//  KEEV
//
//  Created by Doran on 11/6/24.
//

import SwiftUI

/// 만족도 셀
///
/// - Parameters:
///   - rating: 만족도 점수
///
/// - Author: Doran
struct VibeRatingCell: View {
    @Binding private var rating: Double
    
    init(rating: Binding<Double>) {
        self._rating = rating
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: 헤더
            Text("공연의 만족도를 선택해주세요")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium)))
                .foregroundColor(.gray50)
                .padding(.top, 32)
            
            RateSettingView(
                rating: $rating,
                maxRating: 5,
                spacing: 12
            ) { _, _ in
                Image(.star)
            }
            .frame(height: 48)
            .padding(.top, 8)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    VibeRatingCell(rating: .constant(3.5)).backgroundForKEEV()
}
