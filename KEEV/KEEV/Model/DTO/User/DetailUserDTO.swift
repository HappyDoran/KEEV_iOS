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
    let followerCount: Int
    let followingCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case nickname
        case profileImageURL
        case backgroundImageURL
        case description
        case signupDate = "createdDate"
        case followerCount
        case followingCount
    }
}
