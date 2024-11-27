//
//  VibeDTO.swift
//  KEEV
//
//  Created by Yune Cho on 11/28/24.
//

import Foundation

struct VibeDTO: Decodable, Hashable, Identifiable {
    let id: Int
    let user: SimpleUserDTO
    let event: SimpleEventDTO
    let rating: Double
    let comment: String?
    let imageURLs: [String?]
    let createdDate: Date
    let likeCount: Int
    let replyCount: Int
}
