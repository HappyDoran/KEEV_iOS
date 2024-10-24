//
//  CustomAlertViewModifier.swift
//  KEEVTest
//
//  Created by Doran on 10/23/24.
//

import SwiftUI
/// 프로젝트에서 전반적으로 재사용되는 Alert 창
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
/// - Note: 제일 바깥쪽 컨테이너에 motifier로 사용해야 합니다.
/// - Author: Doran
struct CustomAlertViewModifier: ViewModifier {
    private let title: String
    private let message: String
    private let leftButtonText: String
    private let rightButtonText: String
    private let leftAction: () -> Void
    private let rightAction: () -> Void
    private let isPresented: Bool

    init(title: String, message: String, leftButtonText: String, rightButtonText: String, leftAction: @escaping () -> Void, rightAction: @escaping () -> Void, isPresented: Bool) {
        self.title = title
        self.message = message
        self.leftButtonText = leftButtonText
        self.rightButtonText = rightButtonText
        self.leftAction = leftAction
        self.rightAction = rightAction
        self.isPresented = isPresented
    }

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                Color.black.opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
                // brandColor500 - black
                // grayColor300 - orange
                // grayColor800 - pink
                VStack(spacing: 20) {
                    Text(title)
                        .figmaFont(PretendardFont.title(style: .xs)).foregroundColor(.black)
                    
                    Text(message)
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium))).foregroundColor(.orange)
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                    
                    HStack(spacing: 8) {
                        Button(action: {
                            leftAction() }){
                                Text(leftButtonText)
                                    .fixedSize()
                                    .foregroundColor(.white)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding()
                                    .background(Color.blue)
                            }
                        Button(action: {
                            rightAction() }){
                                Text(rightButtonText)
                                    .fixedSize()
                                    .foregroundColor(.white)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding()
                                    .background(Color.blue)
                            }
                    }
                }
                .padding(.horizontal, 20)
                .frame(width: 310, height: 173)
                .background(Color.pink)
                .cornerRadius(16)
                .shadow(radius: 20)
                .transition(.scale)
                .zIndex(1)
            }
        }
    }
}
