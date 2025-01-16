//
//  UserDTO.swift
//  KEEV
//
//  Created by Doran on 11/21/24.
//

import Foundation

struct DetailUserDTO: Decodable, Hashable, Identifiable {
    let id: Int
    let nickname: String
    let profileImageURL: String?
    let backgroundImageURL: String?
    let description: String
    let signupDate: Date
}
