//
//  VibeRatingCell.swift
//  KEEV
//
//  Created by Doran on 11/6/24.
//

import SwiftUI

struct VibeRatingCell: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("공연의 만족도를 선택해주세요")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium)))
                .foregroundColor(.gray50)
            
            RateSettingView(
                rating: .constant(3.5),
                maxRating: 5,
                spacing: 12
            ) { _, _ in
                Image(.star)
            }
            .frame(height: 48)
            .padding(.top, 8)
        }
        .frame(height: 141)
        .frame(maxWidth: .infinity)
        .background(Color.gray900)
    }
}

#Preview {
    VibeRatingCell().backgroundForKEEV()
}
