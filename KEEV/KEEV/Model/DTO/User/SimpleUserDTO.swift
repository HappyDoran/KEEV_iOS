//
//  SimpleUserDTO.swift
//  KEEV
//
//  Created by Yune Cho on 11/28/24.
//

import Foundation

struct SimpleUserDTO: Decodable, Hashable, Identifiable {
    let id: Int
    let nickname: String
    let profileImageURL: String?
}
