//
//  UserFollowDTO.swift
//  KEEV
//
//  Created by Yune Cho on 4/11/25.
//

import Foundation

struct UserFollowDTO: Decodable, Hashable, Identifiable {
    let id: Int
    let nickname: String
    let profileImageURL: String?
    let vibeCount: Int
    let interestedEventCount: Int
    let isFollowing: Bool
}
