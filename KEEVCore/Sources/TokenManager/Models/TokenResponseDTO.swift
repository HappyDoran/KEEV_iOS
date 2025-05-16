//
//  TokenResponseDTO.swift
//  KEEVCore
//
//  Created by junsungkim on 5/16/25.
//

import Foundation

struct TokenResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String?
    let createdDate: Date
}
