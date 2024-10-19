//
//  FontProtocol.swift
//  KEEV
//
//  Created by 김준성 on 10/19/24.
//

import SwiftUI

typealias CustomFontable = Fontable & LineHeightable & LetterSpaceable

protocol Fontable {
    var font: Font { get }
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
