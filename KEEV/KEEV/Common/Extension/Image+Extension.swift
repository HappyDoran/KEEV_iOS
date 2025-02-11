//
//  Image+Extension.swift
//  KEEV
//
//  Created by 김준성 on 2/10/25.
//

import SwiftUI

extension Image {
    /// 이미지를 사각형으로 크롭하는 함수.
    ///
    /// - Parameters:
    ///   - width: 이미지의 너비이며, 기본적으로 `nil`입니다.
    ///   - height: 이미지의 높이이며, 기본적으로 160입니다.
    ///
    /// - Author: newJunsung
    func cropToRectangle(width: CGFloat? = nil, height: CGFloat? = 160) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: height, alignment: .center)
            .clipped()
            .contentShape(Rectangle())
    }
}
