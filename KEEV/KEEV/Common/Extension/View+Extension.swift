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
    /// 기본적인 사용 예시는 아래와 같습니다.
    /// ```swift
    ///  ZStack {
    ///     Color.grayColor950
    ///     VStack(spacing: 20) {
    ///         CustomButton(title: "지금 기록하러 가기!", action: { print("hello world")}, style: .goToRecord)
    ///                 ...
    ///         }
    ///     }
    ///  }.customAlert(isPresented: $showAlert,
    ///                title: "잠깐!",
    ///                message: "공연을 변경하면 작성하던 내용이 사라집니다.\n다른 공연을 선택하시겠어요?",
    ///                isPresented: $showAlert,
    ///                closeText: "취소",
    ///                closeAction: {print("취소")}
    ///  )
    /// ```
    ///
    /// `someText`와 `someAction`의 경우에는 옵셔널 타입이기 때문에 모달에서 이루어지는 특별한 액션이 있는 경우 추가로 넣어서 사용하면 됩니다.
    ///
    /// 사용 예시는 아래와 같습니다.
    /// ```swift
    ///  ZStack {
    ///     Color.grayColor950
    ///     VStack(spacing: 20) {
    ///         CustomButton(title: "지금 기록하러 가기!", action: { print("hello world")}, style: .goToRecord)
    ///                 ...
    ///         }
    ///     }
    ///  }.customAlert(isPresented: $showAlert,
    ///                title: "잠깐!",
    ///                message: "공연을 변경하면 작성하던 내용이 사라집니다.\n다른 공연을 선택하시겠어요?",
    ///                isPresented: $showAlert,
    ///                closeText: "취소",
    ///                closeAction: {print("취소")},
    ///                someText: "공연 변경",
    ///                someAction: {print("공연 변경")}
    ///  )
    /// ```
    ///
    /// - Returns: Custom된 alert 뷰
    ///
    /// - Author: Doran, 라움
    func customAlert(isPresented: Binding<Bool>, title: String = "", message: String = "", firstButtonText: String, firstButtonStyle: AlertButtonStyle, firstButtonAction: @escaping () -> Void, secondButtonText: String? = nil, secondButtonStyle: AlertButtonStyle? = nil, secondButtonAction: (() -> Void)? = nil) -> some View {
        modifier(CustomAlertViewModifier(
            isPresented: isPresented,
            title: title,
            message: message,
            firstButtonText: firstButtonText,
            firstButtonStyle: firstButtonStyle,
            firstButtonAction: firstButtonAction,
            secondButtonText: secondButtonText,
            secondButtonStyle: secondButtonStyle,
            secondButtonAction: secondButtonAction
        ))
    }
    
    /// 커스텀 액션 시트를 표시하는 ViewModifier를 적용하는 함수
    ///
    /// - Parameters:
    ///   - isPresented: 액션 시트의 표시 여부를 제어하는 바인딩 변수
    ///   - configurations: 버튼에 표시할 정보들이 담긴 ButtonConfiguration 프로토콜 배열
    ///
    /// SelectionContent 배열을 넘겨줄 때 SelectionButtonPreset에 설정된 프리셋을 넘겨주시기 바랍니다.
    ///
    /// [any ButtonConfiguration]을 인자로 넘기는 것에 대한 예시입니다,
    ///
    /// ```swift
    /// DummyView()
    ///     .actionSheetForKEEV(
    ///         isPresented: $isPresented,
    ///         configurations: [
    ///             KEEVActionSheet.DefaultConfiguration.delete(title: "hihi", action: {}),
    ///             KEEVActionSheet.DefaultConfiguration.delete(title: "yoyo", action: {}),
    ///             KEEVActionSheet.DefaultConfiguration.delete(title: "soso", action: {})
    ///         ]
    ///   )
    /// ```
    ///
    /// - Returns: Custom된 ActionSheet 뷰
    ///
    /// - Author: 라움
    func actionSheetForKEEV(isPresented: Binding<Bool>, configurations: [any KEEVButtonConfiguration]) -> some View {
        modifier(
            KEEVActionSheet.Modifier(
                isPresented: isPresented,
                configurations: configurations
            )
        )
    }
    
    /// 커스텀 액션 시트를 표시하는 ViewModifier를 적용하는 함수
    ///
    /// - Parameters:
    ///   - isPresented: 액션 시트의 표시 여부를 제어하는 바인딩 변수
    ///   - configurations: 버튼에 표시할 정보들이 담긴 KEEVActionSheet.DefaultConfiguration 배열
    ///
    /// 배열을 넘겨줄 때 전역함수로 설정된 함수들을 대신 넘겨줄 수 있습니다.
    ///
    /// 전역함수를 인자로 넘기는 것에 대한 예시입니다,
    ///
    /// ```swift
    /// VStack {
    ///     Button("hihi") {
    ///         isPresented = true
    ///     }
    /// }
    /// .actionSheetForKEEV(
    ///     isPresented: $isPresented,
    ///     defaults: .myComment(modifyHandler: {}, deleteHandler: {})
    /// )
    /// ```
    ///
    /// - Returns: Custom된 ActionSheet 뷰
    ///
    /// - Author: newJunsung
    func actionSheetForKEEV(isPresented: Binding<Bool>, defaults: [KEEVActionSheet.ButtonConfiguration]) -> some View {
        modifier(
            KEEVActionSheet.Modifier(
                isPresented: isPresented,
                configurations: defaults
            )
        )
    }
    
    /// KEEV 앱에서 보여주는 Toast
    ///
    /// - Parameters:
    ///   - toast: toast를 통해 표현하고 싶은 내용을 담습니다.
    ///   - duration: 이 Toast를 얼만큼의 단위 시간동안 보여줄지 결정합니다.
    ///
    /// 사용 예시는 아래와 같습니다.
    /// ```swift
    /// VStack {
    ///     Button("hi") {
    ///         toast = .init(title: "gogogogo", mainColor: .blue200, subColor: .white)
    ///     }
    ///     Text("Hello World")
    /// }
    /// .toast(with: $toast, for: .seconds(of: 1))
    /// ```
    ///
    /// - Note: 바인딩된 `Toast`는 뷰가 사라지고 나서 `nil`이 됩니다.
    /// - Warning: 해당 수정자를 사용하게 되면 뷰 프레임의 최대 높이와 최대 너비 모두 `.infinity`가 됩니다.
    ///
    /// - Author: newJunsung
    func toast(with toast: Binding<Toast?>, for duration: TimeUnit) -> some View {
        modifier(
            Toast.Modifier(toast: toast, duration: duration)
        )
    }
}
