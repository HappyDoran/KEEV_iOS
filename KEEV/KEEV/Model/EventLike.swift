//
//  EventLikeCount.swift
//  KEEV
//
//  Created by Doran on 1/25/25.
//

import Foundation

struct EventLikeCount: Decodable {
    let count: Int
}

struct EventIsLiked: Decodable {
    let isInterested: Bool
}

struct EventLikeResponse: Decodable {
    let message: String
    let isInterested: Bool
}
