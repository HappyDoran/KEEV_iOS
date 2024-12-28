//
//  AccountDTO.swift
//  KEEV
//
//  Created by 김준성 on 12/26/24.
//

import Foundation

struct AccountDTO: Decodable {
    let id: Int
    let nickname: String?
    let email: String?
    let description: String?
    let backgroundImageURL: String?
    let profileImageURL: String?
    let signUpDate: String?
    
    let accessToken: String
    let keevRefreshToken: String?
}
