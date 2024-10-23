//
//  CommonButton.swift
//  KEEV
//
//  Created by Doran on 10/23/24.
//

import SwiftUI

/// 프로젝트에서 전반적으로 사용되는 버튼을 구현한 구조체
///
/// - Parameters:
///   - title: 버튼 텍스트
///   - action: 버튼 액션
///   - style: 버튼의 스타일 : CommonButtonStyle
///
/// - Note: CommonButtonStyle을 통해 각 상황에 맞는 버튼 스타일을 지정할 수 있습니다.
/// - Author: Doran
struct CommonButton: View {
    private let title: String
    private let action: () -> Void
    private var style: CommonButtonStyle = .submit(isEnabled: true)
    private let cornerRadius: CGFloat = 16
    
    init(title: String, action: @escaping () -> Void, style: CommonButtonStyle) {
        self.title = title
        self.action = action
        self.style = style
    }

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .semibold)))
                .frame(width: style.width, height: style.height)
                .frame(maxWidth: style.maxWidth)
                .background(style.backgroundColor)
                .foregroundColor(style.foregroundColor)
                .cornerRadius(cornerRadius)
        }

    }
}


#Preview {
    CommonButton(title: "지금 기록하러 가기!", action: { print("hello world")}, style: .goToRecord)
    
    CommonButton(title: "작성완료", action: { print("hello world")}, style: .submit(isEnabled: true))
    
    CommonButton(title: "작성완료", action: { print("hello world")}, style: .submit(isEnabled: false)).disabled(true)
    
    HStack(spacing: 0) {
        CommonButton(title: "취소", action: { print("hello world")}, style: .alert(isPositive: true))
        
        CommonButton(title: "공연 변경", action: { print("hello world")}, style: .alert(isPositive: false))
    }
    CommonButton(title: "공연 등록 요청하기", action: { print("hello world")}, style: .request)
}

