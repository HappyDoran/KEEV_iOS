//
//  Modifier.swift
//  KEEV
//
//  Created by Yune Cho on 10/29/24.
//

import SwiftUI

extension KEEVActionSheet {
    /// Keev 내에서 사용되는 액션 시트
    ///
    /// Keev 내에서 사용되는 액션 시트입니다.
    ///
    /// 액션 시트의 표시 여부를 제어하는 바인딩 변수와 버튼에 표시할 정보들이 담긴 KEEVButtonConfiguration 프로토콜을 채택한 배열를 인자로 받아서 커스텀된 액션 시트를 보여줍니다.
    ///
    /// KEEVButtonConfiguration 배열을 넘겨줄 때 액션 시트에 기본으로 구현된 ButtonConfiguration을 넘겨줄 수도 있습니다.
    ///
    /// ButtonConfiguration의 custom 케이스 사용에 대한 예시입니다.
    ///
    /// ```swift
    /// VStack {
    ///     Text("fefe")
    /// }
    /// .modifier(
    ///     KEEVActionSheet.Modifier(
    ///         isPresented: $isPresented,
    ///         defaults: .concert(shareHandler: {}, reportHandler: {})
    ///     )
    /// )
    /// ```
    ///
    /// KEEVButtonConfiguration을 채택한 타입을 담은 배열을 인자로 넘기는 것에 대한 예시입니다.
    ///
    ///```swift
    /// VStack {
    ///     Text("fefe")
    /// }
    /// .modifier(
    ///     KEEVActionSheet.Modifier(
    ///         isPresented: $isPresented,
    ///         configurations: [
    ///             KEEVActionSheet.DefaultConfiguration.delete(title: "hihi", action: {}),
    ///             KEEVActionSheet.DefaultConfiguration.delete(title: "yoyo", action: {}),
    ///             KEEVActionSheet.DefaultConfiguration.delete(title: "soso", action: {})
    ///         ]
    ///     )
    /// )
    /// ```
    ///
    /// - Note: 액션 시트의 ButtonConfiguration 배열을 넘겨줄 때 기본 설정인 전역 함수를 넘겨줄 수도 있습니다.
    /// - Author: 라움
    struct Modifier: ViewModifier {
        @Binding var isPresented: Bool
        private let configurations: [any KEEVButtonConfiguration]
        
        init(isPresented: Binding<Bool>, configurations: [any KEEVButtonConfiguration]) {
            self._isPresented = isPresented
            self.configurations = configurations
        }
        
        init(isPresented: Binding<Bool>, defaults: [KEEVActionSheet.ButtonConfiguration]) {
            self._isPresented = isPresented
            self.configurations = defaults
        }
        
        /// Modifier가 적용된 새로운 뷰를 리턴하는 함수
        ///
        /// - Parameters:
        ///   - content: 기존 뷰
        ///
        /// Modifier가 적용된 새로운 뷰를 리턴하는 함수입니다.
        ///
        /// - Returns: Custom된 ActionSheet 뷰
        ///
        /// - Author: 라움
        func body(content: Content) -> some View {
            ZStack {
                content
                
                if isPresented {
                    Color.black
                        .opacity(0.7)
                        .ignoresSafeArea(.all)
                    
                    KEEVActionSheet(isPresented: $isPresented, configurations: configurations)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 44)
                        .transition(.move(edge: .bottom))
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .animation(.snappy, value: isPresented)
            .onTapGesture {
                isPresented = false
            }
        }
    }
}
