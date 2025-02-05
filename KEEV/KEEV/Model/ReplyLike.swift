//
//  ReplyLike.swift
//  KEEV
//
//  Created by Yune Cho on 1/27/25.
//

import Foundation

struct ReplyLikeResponse: Decodable {
    let isLiked: Bool
    let message: String
}
