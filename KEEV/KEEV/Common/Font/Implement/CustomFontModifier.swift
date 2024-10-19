//
//  CustomFontModifier.swift
//  KEEV
//
//  Created by 김준성 on 10/19/24.
//

import SwiftUI

/// 외부의 사용자 지정 글꼴을 적용하는 글꼴
///
/// CustomFontable 프로토콜을 채택한 타입을 받아 사용합니다.
/// 사용 예시는 아래와 같습니다.
/// ```swift
/// Text("Hello World!")
///     .modifier(CustomFontModifier(PretendardFont.title(style: PretendardFont.title(style: .xl)))
/// ```
///
/// - Note: `CustomFontable`은 `Fontable`와 `LineHeightable`, `LetterSpaceable`을 합친 프로토콜입니다.
/// - Author: newJunsung
struct CustomFontModifier: ViewModifier {
    private let customFont: CustomFontable
    
    init(_ customFont: CustomFontable) {
        self.customFont = customFont
    }
    
    func body(content: Content) -> some View {
        content
            .font(customFont.font)
            .tracking(customFont.letterSpace)
            .lineSpacing(customFont.lineHeight)
    }
}
