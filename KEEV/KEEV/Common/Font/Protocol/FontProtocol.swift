//
//  FontProtocol.swift
//  KEEV
//
//  Created by 김준성 on 10/19/24.
//

import SwiftUI

typealias FigmaFontable = Fontable & LineHeightable & LetterSpaceable

protocol Fontable {
    var uiFont: UIFont { get }
}

protocol FontSizeable {
    var fontSize: CGFloat { get }
}

protocol LineHeightable {
    var lineHeight: CGFloat { get }
}

protocol LetterSpaceable {
    var letterSpace: CGFloat { get }
}
