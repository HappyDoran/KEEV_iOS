//
//  KEEVBackgroundModifier.swift
//  KEEV
//
//  Created by 김준성 on 10/29/24.
//

import SwiftUI

/// 피그마에 있는 배경색으로 바꾸기 위한 ViewModifier
///
/// 우선 기본적으로 라이트모드가 지원되지 않기 때문에,
///
/// 배경색은 `gray950`으로 통일되어 있습니다.
///
/// - Important: `ZStack`으로 내부가 구현되어 있어서, 뷰의 `modifier`들의 가장 마지막에 호출하는 것을 권장드립니다.
///
/// - Author: newJunsung
struct KEEVBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color.gray950
                .ignoresSafeArea(.all, edges: .all)
            content
        }
    }
}

#Preview {
    NavigationStack {
        DummyScreen()
            .navigationTitle("안녕, 세상")
            .modifier(KEEVBackgroundModifier())
    }
        
}
