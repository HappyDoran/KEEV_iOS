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
    var version: String { get }
    var notices: [Notice] { get }
    var termsOfUse: String { get }
    var privacyPolicy: String { get }
    
    func send(openURL: OpenURLAction)
}
