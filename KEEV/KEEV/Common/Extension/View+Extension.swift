//
//  View+Extension.swift
//  KEEV
//
//  Created by 김준성 on 10/19/24.
//

import SwiftUI

extension View {
    /// 사용자 지정 글꼴을 뷰에 지정해주는 함수.
    ///
    /// - Parameters:
    ///   - figmaFont: FigmaFontable을 채택한 타입
    ///
    /// CustomFontable을 채택한 타입의 글꼴로 변합니다.
    /// 아래는 사용 예시입니다.
    /// ```swift
    /// Text("Hello World!!!")
    ///     .figmaFont((PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium)))
    /// ```
    ///
    /// - Returns: 기존에서 글꼴이 변경된 뷰
    /// - Author: newJunsung
    func figmaFont(_ figmaFont: some FigmaFontable) -> some View {
        modifier(FigmaFontModifier(figmaFont))
    }
    
    /// 커스텀 경고창을 표시하는 ViewModifier를 적용하는 함수
    ///
    /// - Parameters:
    ///   - title: 알림의 제목
    ///   - message: 알림의 메시지
    ///   - isPresented: 알림의 표시 여부를 제어하는 바인딩 변수
    ///   - leftButtonText: 왼쪽 버튼의 텍스트
    ///   - rightButtonText: 오른쪽 버튼의 텍스트
    ///   - leftAction: 왼쪽 버튼 클릭 시 실행될 액션
    ///   - rightAction: 오른쪽 버튼 클릭 시 실행될 액션
    ///
    /// customAlert를 사용하여 사용자 지정 경고창을 만듭니다.
    /// 아래는 사용 예시입니다.
    /// ```swift
    ///  ZStack {
    ///     Color.grayColor950
    ///     VStack(spacing: 20) {
    ///         CustomButton(title: "지금 기록하러 가기!", action: { print("hello world")}, style: .goToRecord)
    ///                 ...
    ///         }
    ///     }
    ///  }.customAlert(title: "잠깐!",
    ///                message: "공연을 변경하면 작성하던 내용이 사라집니다.\n다른 공연을 선택하시겠어요?",
    ///                isPresented: $showAlert,
    ///                leftButtonText: "취소",
    ///                rightButtonText: "공연 변경",
    ///                leftAction: {print("취소")},
    ///                rightAction: {print("공연 변경")}
    ///  )
    /// ```
    ///
    /// - Returns: Custom된 alert 뷰
    ///
    /// - Author: Doran
    func customAlert(title: String, message: String, isPresented: Binding<Bool>, leftButtonText: String, rightButtonText: String, leftAction: @escaping () -> Void, rightAction: @escaping () -> Void ) -> some View {
        modifier(CustomAlertViewModifier(
            title: title,
            message: message,
            leftButtonText: leftButtonText,
            rightButtonText: rightButtonText,
            leftAction: leftAction,
            rightAction: rightAction,
            isPresented: isPresented
        ))
    }
}
