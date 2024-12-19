//
//  RateSettingView.swift
//  KEEV
//
//  Created by 김준성 on 10/23/24.
//

import SwiftUI

/// 탭과 드래그를 통해 평점을 조절하는 뷰.
///
/// 색칠된 이미지와 색칠되지 않은 이미지와 관계없이 이미지를 탭하면, 이미지가 속한 인덱스의 평점으로 변경됩니다.
/// 색칠된 이미지 부분을 드래그하면 자신이 원하는 평점으로 조절할 수 있습니다.
/// `init`을 할 때 필요한 파라미터는 다음과 같습니다.
/// - `rating`: 현재 별점
/// - `maxRating`: 총 별점
/// - `spacing`: 이미지 간의 공간
/// - `image`: 평점을 표현할 이미지
///
/// `image`의 경우 클로저이며, 해당 클로저의 파라미터로 `(Double, Int)`가 들어갑니다.
/// `Double`의 경우 현재 평점이며, `Int`의 경우 이미지의 인덱스 입니다.
///
/// 아래의 코드는 사용 예시입니다.
/// ```swift
/// RateSettingView(
///     rating: .constant(3.5),
///     maxRating: 5,
///     spacing: 12
/// ) { _, _ in
///     Image(systemName: "star.fill")
/// }
/// ```
///
/// - Note: 이 뷰의 경우 0.5 단위로 평점이 조절됩니다. 그리고 왼쪽에서 오른쪽으로만 평점 조절이 가능합니다.
/// - Important: 이 뷰는 Frame을 지정하기 어렵습니다. 이 뷰에서 이미지의 크기는 상위 뷰와 주변 뷰의 크기, 패딩 등으로 결정됩니다.
/// - Author: newJunsung
struct RateSettingView: View {
    @State private var x: CGFloat = 0
    @State private var starWidth = CGFloat.zero
    @Binding private(set) var rating: Double
    
    let maxRating: CGFloat
    let spacing: CGFloat
    let image: (Double, Int) -> Image
    let brandColor: Color = .brand500
    
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
                    .foregroundColor(.gray700)
            }
        }
            .onTapGesture(count: 1, coordinateSpace: .local) { point in
                (rating, x) = calculate(from: point.x)
            }
        
        stars.overlay(
            GeometryReader { geometry in
                HStack {
                    if x > 0 {
                        Rectangle()
                            .foregroundStyle(brandColor)
                            .frame(width: x)
                    }
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
        var left = 0
        var right = 10
        
        while left < right {
            let mid = CGFloat((left + right) / 2)
            let tempSpace: CGFloat
            
            if Int(mid).isMultiple(of: 2) {
                tempSpace = (mid / 2 - 1) * spacing
            } else {
                tempSpace = (mid + 1) / 2 * spacing
            }
            
            let tempX = (mid / 2) * starWidth + tempSpace
            
            if tempX < x {
                left = (left + right) / 2 + 1
            } else {
                right = (left + right) / 2
            }
        }
        
        let correctedRating = Double(left) / 2
        return (correctedRating, starWidth * correctedRating + spacing * floor(correctedRating))
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
