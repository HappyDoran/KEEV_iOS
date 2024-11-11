//
//  SettingServiceProtocol.swift
//  KEEV
//
//  Created by Yune Cho on 11/11/24.
//

import Foundation
import SwiftUI

protocol SettingServiceProtocol {
    var version: String { get }
    var notices: [Notice] { get }
    var termsOfUse: String { get }
    var privacyPolicy: String { get }
    
    func send(openURL: OpenURLAction)
}
