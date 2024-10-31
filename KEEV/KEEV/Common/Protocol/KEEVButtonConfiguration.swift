//
//  KEEVButtonConfiguration.swift
//  KEEV
//
//  Created by 김준성 on 10/31/24.
//

import SwiftUI

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
