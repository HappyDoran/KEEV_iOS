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
    
    init(id: Int, user: SimpleUserDTO, event: SimpleEventDTO, rating: Double, comment: String?, imageURLs: [String?], createdDate: Date, likeCount: Int, replyCount: Int) {
        self.id = id
        self.user = user
        self.event = event
        self.rating = rating
        self.comment = comment
        self.imageURLs = imageURLs
        self.createdDate = createdDate
        self.likeCount = likeCount
        self.replyCount = replyCount
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case user
        case event
        case rating
        case comment = "content"
        case imageURLs = "imageURLList"
        case createdDate
        case likeCount
        case replyCount
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateString = try container.decode(String.self, forKey: .createdDate)
        self.id = try container.decode(Int.self, forKey: .id)
        self.user = try container.decode(SimpleUserDTO.self, forKey: .user)
        self.event = try container.decode(SimpleEventDTO.self, forKey: .event)
        self.rating = try container.decode(Double.self, forKey: .rating)
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
        self.imageURLs = try container.decode([String?].self, forKey: .imageURLs)
        self.createdDate = dateString.toDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSSSS") ?? .now
        self.likeCount = try container.decode(Int.self, forKey: .likeCount)
        self.replyCount = try container.decode(Int.self, forKey: .replyCount)
    }
}
