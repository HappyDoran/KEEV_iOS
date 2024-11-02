//
//  AccountService.swift
//  KEEV
//
//  Created by Yune Cho on 11/2/24.
//

import Foundation
import SwiftUI

class AccountService: AccountServiceProtocol {
    @Published var email: String = ""
    @Published var nickname: String = ""
    @Published var profileImage: UIImage?
    @Published var profileBackgroundImage: UIImage?
    @Published var oneLineExplanation: String?
}
