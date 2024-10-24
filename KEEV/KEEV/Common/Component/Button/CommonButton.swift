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
///   - disabled: 버튼의 활성화
///
/// - Note: CommonButtonStyle을 통해 각 상황에 맞는 버튼 스타일을 지정할 수 있습니다.
///  버튼의 활성화에 대한 변수 disabled에 따라서 버튼의 색이 변경됩니다.
/// - Author: Doran
struct CommonButton: View {
    private let title: String
    private let action: () -> Void
    private let style: CommonButtonStyle
    private let disabled: Bool
    
    init(title: String, action: @escaping () -> Void, style: CommonButtonStyle, disabled: Bool = false) {
        self.title = title
        self.action = action
        self.style = style
        self.disabled = disabled
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium)))
                .frame(width: style.width, height: style.height)
                .frame(maxWidth: style.maxWidth)
                .background(disabled ? .gray900 : style.backgroundColor)
                .foregroundColor(disabled ? .gray500 : style.foregroundColor)
                .cornerRadius(16)
        }
        .disabled(disabled)
    }
}


#Preview {
    @Previewable @State var isDisabled: Bool = true
    
    CommonButton(title: "지금 기록하러 가기!", action: { print("hello world")}, style: .medium)
    
    CommonButton(title: "작성완료", action: { print("hello world") }, style: .maxWidth)
    
    CommonButton(title: "작성완료", action: { print("hello world")}, style: .maxWidth, disabled: isDisabled)
    
    HStack(spacing: 0) {
        CommonButton(title: "취소", action: { print("hello world")}, style: .alert(isActive: false))
        
        CommonButton(title: "공연 변경", action: { print("hello world")}, style: .alert(isActive: true))
    }
    CommonButton(title: "공연 등록 요청하기", action: { print("hello world")}, style: .small)
}


