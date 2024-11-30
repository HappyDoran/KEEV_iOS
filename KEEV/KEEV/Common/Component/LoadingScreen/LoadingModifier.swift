//
//  LoadingModifier.swift
//  KEEV
//
//  Created by 김준성 on 11/30/24.
//

import SwiftUI

/// SwiftUI의 `ViewModifier`로, 비동기 작업이 진행되는 동안 로딩 화면을 표시합니다.
///
/// 이 수정자를 사용하면 애플리케이션이 작업 중임을 나타내기 위해 반투명 로딩 인디케이터를 표시할 수 있습니다.
///
/// ### 개요
/// `LoadingModifier`는 `isLoading` 바인딩 값에 따라 콘텐츠 위에 조건부로 `LoadingView`를 오버레이합니다.
/// 로딩 오버레이는 스타일링된 둥근 사각형 안에 프로그래스 인디케이터를 포함합니다.
///
/// ```swift
/// struct ContentView: View {
///     @State private var isLoading = false
///
///     var body: some View {
///         VStack {
///             Button("Show Loading") {
///                 isLoading = true
///             }
///         }
///         .modifier(LoadingModifier(isLoading: $isLoading))
///     }
/// }
/// ```
///
/// ### 기능
/// - 반투명한 회색 배경과 함께 중앙에 로딩 인디케이터를 표시합니다.
/// - 로딩 화면이 나타나거나 사라질 때 부드러운 투명도 전환을 제공합니다.
/// - 비동기 작업을 나타내기에 적합합니다.
///
/// - Parameters:
/// - `isLoading`: 로딩 오버레이가 표시될지 여부를 제어하는 Boolean 값의 바인딩.
///
/// ### 논의
/// 비동기 작업 중 사용자 경험을 향상시키기 위해 `LoadingModifier`를 사용하세요.
/// 로딩 인디케이터는 가시성을 전환할 때 자동으로 애니메이션을 제공합니다.
///
/// - Note: LoadingView`는 `LoadingModifier` 내부에 있는 private 구조체로, 시각적 요소를 캡슐화합니다. `LoadingView` 구현을 수정하여 로딩 인디케이터의 외형을 사용자화할 수 있습니다.
///
/// - Author: newJunsung
///
struct LoadingModifier: ViewModifier {
    /// 로딩 오버레이의 가시성을 제어하는 바인딩 값입니다.
    @Binding var isLoading: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if isLoading {
                    LoadingView()
                        .transition(.opacity)
                }
            }
            .animation(.default, value: isLoading)
    }
}

private extension LoadingModifier {
    /// 로딩 오버레이를 나타내는 private 뷰입니다.
    struct LoadingView: View {
        var body: some View {
            ZStack {
                // 반투명 배경
                Color.grayBG800
                    .opacity(0.8)
                
                // 프로그래스 인디케이터가 포함된 둥근 사각형
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.grayBG700)
                    .overlay {
                        ProgressView()
                            .tint(.brand500)
                    }
            }
        }
    }
}
