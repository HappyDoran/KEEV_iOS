//
//  Path+Extension.swift
//  KEEV
//
//  Created by Doran on 10/29/24.
//

import SwiftUI

extension Path {
    mutating func checkMark(startPoint: CGPoint, middlePoint: CGPoint, endPoint: CGPoint) {
        self.move(to: startPoint)
        self.addLine(to: middlePoint)
        self.addLine(to: endPoint)
    }
}
