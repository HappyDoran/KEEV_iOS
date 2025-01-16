//
//  SettingServiceProtocol.swift
//  KEEV
//
//  Created by Yune Cho on 11/11/24.
//

import Foundation
import SwiftUI

/// SettingService를 구현하기 위한 프로토콜
///
/// SettingService를 구현하기 위한 프로토콜입니다.
///
/// - Author: 라움
protocol SettingServiceProtocol {
    var notices: [Notice] { get }
    
    func send(openURL: OpenURLAction)
    func termsOfUse() -> String
    func privacyPolicy() -> String
}
