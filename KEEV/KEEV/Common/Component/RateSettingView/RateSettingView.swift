//
//  RateSettingView.swift
//  KEEV
//
//  Created by 김준성 on 10/23/24.
//

import SwiftUI

struct RateSettingView: View {
    @State private var x: CGFloat = 0
    @State private var starWidth = CGFloat.zero
    @Binding private var rating: Double
    
    private let spacing: CGFloat
    private let maxRating: CGFloat
    private let image: (Double, Int) -> Image
    
    init(
        rating: Binding<Double>,
        maxRating: Int,
        spacing: CGFloat,
        image: @escaping (Double, Int) -> Image
    ) {
        self._rating = rating
        self.spacing = spacing
        self.maxRating = CGFloat(maxRating)
        self.image = image
    }
    
    private var spaceCount: CGFloat {
        maxRating - 1 < 0 ? 0 : maxRating - 1
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                x = value.location.x
            }
            .onEnded { value in
                (rating, x) = calculate(from: value.location.x)
            }
    }
    
    var body: some View {
        let stars = HStack(spacing: spacing) {
            ForEach(0..<Int(maxRating), id: \.self) { index in
                image(rating, index)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
            .onTapGesture(count: 1, coordinateSpace: .local) { point in
                (rating, x) = calculate(from: point.x)
            }
        
        stars.overlay(
            GeometryReader { geometry in
                HStack {
                    Rectangle()
                        .foregroundStyle(.red)
                        .frame(width: x)
                    Spacer()
                }
                .onAppear { initialSetting(from: geometry.size) }
                .onChange(of: geometry.size) { _, newSize in
                    initialSetting(from: newSize)
                }
                .onTapGesture(
                    count: 1,
                    coordinateSpace: .local
                ) { point in
                    (rating, x) = calculate(from: point.x)
                }
                .gesture(dragGesture)
            }
        )
        .mask(stars)
    }
    
    private func initialSetting(from size: CGSize) {
        starWidth = (size.width - spaceCount * spacing) / maxRating
        x = starWidth * rating + round(rating - 1) * spacing
    }
    
    private func calculate(from x: CGFloat) -> (Double, CGFloat) {
        let double = maxRating
        let half = starWidth / 2.0
        var stC = 0.0
        var temp: CGFloat = 0
        
        while temp < x {
            temp += half
            stC += 0.5
            if temp >= x { break }
            temp += half + spacing
            stC += 0.5
        }
        stC = stC > double ? double : stC
        
        return (stC, starWidth * Double(stC) + spacing * (round(stC) - 1))
    }
}

#Preview {
    RateSettingView(
        rating: .constant(3.5),
        maxRating: 5,
        spacing: 12
    ) { _, _ in
        Image(systemName: "star.fill")
    }
}
