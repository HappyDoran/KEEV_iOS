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
    ///   - customFont: CustomFontable을 채택한 타입
    ///
    /// CustomFontable을 채택한 타입의 글꼴로 변합니다.
    /// 아래는 사용 예시입니다.
    /// ```swift
    /// Text("Hello World!!!")
    ///     .customFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium)))
    /// ```
    ///
    /// - Returns: 기존에서 글꼴이 변경된 뷰
    /// - Author: newJunsung
    func customFont(_ customFont: some CustomFontable) -> some View {
        modifier(CustomFontModifier(customFont))
    }
}
