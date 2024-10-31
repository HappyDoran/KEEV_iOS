//
//  ActionSheet.swift
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
    /// 액션 시트의 표시 여부를 제어하는 바인딩 변수와 버튼에 표시할 정보들이 담긴 SelectionButtonContent 배열를 인자로 받아서 커스텀된 액션 시트를 보여줍니다.
    ///
    /// SelectionButtonContent 배열을 넘겨줄 때 SelectionButtonPreset에 설정된 프리셋을 넘겨주시기 바랍니다.
    ///
    /// SelectionButtonPreset을 인자로 넘기는 것에 대한 예시입니다,
    ///
    /// ```swift
    /// DummyView()
    ///     .customActionSheet(isPresented: $showActionSheet, buttons: SelectionButtonPreset.setProfileImage.buttons())
    /// ```
    ///
    /// SelectionButtonPreset의 custom 케이스 사용에 대한 예시입니다.
    ///
    ///```swift
    /// DummyView()
    ///     .customActionSheet(isPresented: $showActionSheet, buttons: SelectionButtonPreset.custom([
    ///         SelectionButtonContent(type: .modify, title: "Rename", action: { print("Rename") }),
    ///         SelectionButtonContent(type: .delete, title: "Delete", action: { print("Delete") }),
    ///         SelectionButtonContent(type: .report, title: "Report", action: { print("Report") })
    ///     ]).buttons())
    /// ```
    ///
    /// - Note: SelectionButtonContent 배열을 넘겨줄 때 SelectionButtonPreset에 설정된 프리셋을 넘겨주시기 바랍니다.
    /// - Author: 라움
    struct Modifier: ViewModifier {
        @Binding var isPresented: Bool
        private let configurations: [any KEEVActionSheet.ButtonConfiguration]
        
        init(isPresented: Binding<Bool>, configurations: [any KEEVActionSheet.ButtonConfiguration]) {
            self._isPresented = isPresented
            self.configurations = configurations
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
            .ignoresSafeArea()
            .animation(.snappy, value: isPresented)
            .onTapGesture {
                isPresented = false
            }
        }
    }
}
