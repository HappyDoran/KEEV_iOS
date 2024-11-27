//
//  ViewHeightPreferenceKey.swift
//  KEEV
//
//  Created by 김준성 on 11/23/24.
//

import SwiftUICore

final class ViewHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
