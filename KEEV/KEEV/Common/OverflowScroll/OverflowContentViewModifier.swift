//
//  OverflowContentViewModifier.swift
//  KEEV
//
//  Created by Doran on 12/17/24.
//

import SwiftUI

/// 콘텐츠의 크기에 따라 스크롤이 활성화되고 활성화 되지 않는 것을 위한 ViewModifier
///
/// 전체 화면 사이즈와, 콘텐츠의 사이즈를 계산하여 콘텐츠 사이즈가 전체 화면 사이즈보다 크면 스크롤이 활성화 됩니다.
///
/// - Important: `contentGeometry`의 사이즈만 변하는게 아니라 `geometry`의 사이즈 또한 변하기 떄문에 이 두 상황 모두에 onChange를 적용하여 판별해줘야 합니다.
/// - Author: Doran
struct OverflowContentViewModifier: ViewModifier {
    @State private var contentOverflow: Bool = false
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
            .background(
                GeometryReader { contentGeometry in
                    Color.clear
                        .onAppear {
                            updateContentOverflow(contentHeight: contentGeometry.size.height, geometryHeight: geometry.size.height)
                        }
                        .onChange(of: contentGeometry.size.height) { _, newHeight in
                            updateContentOverflow(contentHeight: newHeight, geometryHeight: geometry.size.height)
                        }
                        .onChange(of: geometry.size.height) { _, newHeight in
                            updateContentOverflow(contentHeight: contentGeometry.size.height, geometryHeight: newHeight)
                        }
                }
            )
            .wrappedInScrollView(when: contentOverflow)
        }
    }
}

extension OverflowContentViewModifier {
    private func updateContentOverflow(contentHeight: CGFloat, geometryHeight: CGFloat) {
        contentOverflow = contentHeight > geometryHeight
    }
}

