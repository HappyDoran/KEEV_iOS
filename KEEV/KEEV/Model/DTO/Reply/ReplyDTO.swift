//
//  ReplyDTO.swift
//  KEEV
//
//  Created by Doran on 11/27/24.
//

import Foundation

struct ReplyDTO: Decodable, Hashable, Identifiable {
    let id: Int
    
    let userID: Int
    
    let userNickname: String
    
    let userProfileImageURL: URL?
    
    let vibeID: Int
    
    let text: String
    
    let isLiked: Bool
    
    let likeCount: Int
    
    let createdDate: Date

}
