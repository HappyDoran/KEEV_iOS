//
//  CustomAlertViewModifier.swift
//  KEEV
//
//  Created by Doran on 10/23/24.
//

import SwiftUI
/// 프로젝트에서 전반적으로 재사용되는 Alert 창
///
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
/// - Note: 제일 바깥쪽 컨테이너에 motifier로 사용해야 합니다.
///
/// - Author: Doran, 라움
struct CustomAlertViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    private let title: String
    private let message: String
    private let firstButtonText: String
    private let firstButtonStyle: AlertButtonStyle
    private let firstButtonAction: (() -> Void)
    private let secondButtonText: String?
    private let secondButtonStyle: AlertButtonStyle?
    private let secondButtonAction: (() -> Void)?
    
    init(isPresented: Binding<Bool>, title: String = "", message: String = "", firstButtonText: String, firstButtonStyle: AlertButtonStyle, firstButtonAction: @escaping () -> Void, secondButtonText: String? = nil, secondButtonStyle: AlertButtonStyle? = nil, secondButtonAction: (() -> Void)? = nil) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.firstButtonText = firstButtonText
        self.firstButtonStyle = firstButtonStyle
        self.firstButtonAction = firstButtonAction
        self.secondButtonText = secondButtonText
        self.secondButtonStyle = secondButtonStyle
        self.secondButtonAction = secondButtonAction
    }

    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                Color.black
                    .opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isPresented = false
                    }
                
                VStack(spacing: 0) {
                    if !title.isEmpty {
                        Text(title)
                            .figmaFont(PretendardFont.title(style: .xs))
                            .foregroundColor(.gray100)
                    }
                    
                    if !message.isEmpty {
                        Text(message)
                            .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium)))
                            .foregroundColor(.gray300)
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                            .padding(.top, title.isEmpty ? 0 : 12)
                    }
                    
                    HStack(spacing: 8) {
                        CommonButton(
                            title: firstButtonText,
                            action: {
                                firstButtonAction()
                                isPresented.toggle()
                            },
                            style: .alert(type: firstButtonStyle)
                        )
                        
                        if let secondButtonText = secondButtonText, let secondButtonStyle = secondButtonStyle, let secondButtonAction = secondButtonAction {
                            CommonButton(
                                title: secondButtonText,
                                action: {
                                    secondButtonAction()
                                    isPresented.toggle()
                                },
                                style: .alert(type: secondButtonStyle)
                            )
                        }
                    }
                    .padding(.top, 16)
                }
                .padding(.all, 20)
                .frame(width: 310)
                .background(Color.gray800)
                .cornerRadius(16)
                .zIndex(1)
                .transition(.scale)
            }
        }
        .animation(.snappy(duration: 0.3), value: isPresented)
        .sensoryFeedback(.warning, trigger: isPresented)
    }
}
