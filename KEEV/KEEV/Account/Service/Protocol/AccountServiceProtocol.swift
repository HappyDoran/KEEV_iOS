//
//  AccountServiceProtocol.swift
//  KEEV
//
//  Created by Yune Cho on 11/2/24.
//

import Foundation
import SwiftUI

protocol AccountServiceProtocol: ObservableObject {
    var email: String { get }
    var nickname: String { get }
    var profileImage: UIImage? { get }
    var profileBackgroundImage: UIImage? { get }
    var oneLineExplanation: String? { get }
}
