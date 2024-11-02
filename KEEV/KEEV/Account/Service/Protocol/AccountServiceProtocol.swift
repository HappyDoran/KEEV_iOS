//
//  AccountServiceProtocol.swift
//  KEEV
//
//  Created by Yune Cho on 11/2/24.
//

import Foundation
import SwiftUI

protocol AccountServiceProtocol: ObservableObject {
    var email: String { get set }
    var nickname: String { get set }
    var profileImage: UIImage? { get set }
    var profileBackgroundImage: UIImage? { get set }
    var oneLineExplanation: String? { get set }
}
