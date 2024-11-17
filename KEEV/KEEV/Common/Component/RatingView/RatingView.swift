//
//  RatingView.swift
//  KEEV
//
//  Created by Yune Cho on 11/17/24.
//

import SwiftUI

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
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray700)
            }
        }
        
        stars.overlay(
            GeometryReader { geometry in
                Rectangle()
                    .foregroundStyle(.gray300)
                    .frame(width: rating / maxRating * geometry.size.width)
            }
        )
        .mask(stars)
    }
}

#Preview {
    RatingView(rating: 3.5, image: Image(systemName: "star.fill"))
}
