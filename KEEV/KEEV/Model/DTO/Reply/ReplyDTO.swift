//
//  ReplyDTO.swift
//  KEEV
//
//  Created by Doran on 11/27/24.
//

import Foundation

struct ReplyDTO: Decodable, Hashable, Identifiable {
    let id: Int
    
    let user: SimpleUserDTO
    
    let vibeID: Int
    
    let text: String
    
    let isLiked: Bool
    
    let likeCount: Int
    
    let createdDate: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case user
        case vibeID = "vibeId"
        case text = "content"
        case isLiked = "liked"
        case likeCount
        case createdDate
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let tempCreatedDate = try container.decode(String.self, forKey: .createdDate)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.user = try container.decode(SimpleUserDTO.self, forKey: .user)
        self.vibeID = try container.decode(Int.self, forKey: .vibeID)
        self.text = try container.decode(String.self, forKey: .text)
        self.isLiked = try container.decode(Bool.self, forKey: .isLiked)
        self.likeCount = try container.decode(Int.self, forKey: .likeCount)
        self.createdDate = tempCreatedDate.toDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSSSS") ?? .now
    }
}
