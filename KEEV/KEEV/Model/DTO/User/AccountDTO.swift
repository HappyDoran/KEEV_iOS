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
    let description: String
    let backgroundImageURL: String
    let profileImageURL: String
    let followerCount: Int
    let followingCount: Int
    let signUpDate: String?
    let accessToken: String?
    let keevRefreshToken: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nickname
        case email
        case description
        case backgroundImageURL
        case profileImageURL
        case followerCount
        case followingCount
        case signUpDate = "createdDate"
        case accessToken
        case keevRefreshToken = "refreshToken"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.nickname = try container.decodeIfPresent(String.self, forKey: .nickname)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.description = try container.decode(String.self, forKey: .description)
        self.backgroundImageURL = try container.decode(String.self, forKey: .backgroundImageURL)
        self.profileImageURL = try container.decode(String.self, forKey: .profileImageURL)
        self.followerCount = try container.decode(Int.self, forKey: .followerCount)
        self.followingCount = try container.decode(Int.self, forKey: .followingCount)
        self.signUpDate = try container.decodeIfPresent(String.self, forKey: .signUpDate)
        self.accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
        self.keevRefreshToken = try container.decodeIfPresent(String.self, forKey: .keevRefreshToken)
    }
}
