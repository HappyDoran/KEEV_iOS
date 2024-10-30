//
//  ActionSheet.swift
//  KEEV
//
//  Created by Yune Cho on 10/29/24.
//

import Foundation
import SwiftUI

/// Keev 내에서 사용되는 액션 시트
///
/// Keev 내에서 사용되는 액션 시트입니다.
///
/// 액션 시트의 표시 여부를 제어하는 바인딩 변수와 버튼에 표시할 정보들이 담긴 CustomActionSheetButtonContent 배열를 인자로 받아서 커스텀된 액션 시트를 보여줍니다.
///
/// CustomActionSheetButtonContent 배열을 넘겨줄 때 CustomActionSheetButtonPreset에 설정된 프리셋을 넘겨주시기 바랍니다.
///
/// CustomActionSheetButtonPreset을 인자로 넘기는 것에 대한 예시입니다,
///
/// ```swift
/// DummyView()
///     .customActionSheet(isPresented: $showActionSheet, buttons: CustomActionSheetButtonPreset.setProfileImage.buttons())
/// ```
///
/// - Note: CustomActionSheetButtonContent 배열을 넘겨줄 때 CustomActionSheetButtonPreset에 설정된 프리셋을 넘겨주시기 바랍니다.
/// - Author: 라움
struct CustomActionSheetModifier: ViewModifier {
    @Binding var isPresented: Bool
    private let buttons: [CustomActionSheetButtonContent]
    
    init(isPresented: Binding<Bool>, buttons: [CustomActionSheetButtonContent]) {
        self._isPresented = isPresented
        self.buttons = buttons
    }
    
    /// Modifier가 적용된 새로운 뷰를 리턴하는 함수
    ///
    /// - Parameters:
    ///   - content: 기존 뷰
    ///
    /// CustomActionSheetModifier가 적용된 새로운 뷰를 리턴하는 함수입니다.
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
                
                VStack(spacing: 16) {
                    Spacer()
                    
                    VStack(spacing: 0) {
                        ForEach(buttons) { button in
                            CustomActionSheetButton(button: button)
                        }
                    }
                    
                    CustomActionSheetCloseButton(isPresented: $isPresented)
                }
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
