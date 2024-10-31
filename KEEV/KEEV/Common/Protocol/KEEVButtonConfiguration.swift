//
//  KEEVButtonConfiguration.swift
//  KEEV
//
//  Created by 김준성 on 10/31/24.
//

import SwiftUI

/// KEEV에서 자주 사용되는 버튼을 기본 구현하기 위한 프로토콜
protocol KEEVButtonConfiguration: Identifiable {
    var title: String { get }
    var image: Image? { get }
    var mainColor: Color { get }
    var subColor: Color? { get }
    var action: () -> Void { get }
}

extension KEEVButtonConfiguration {
    var id: String { title }
}
