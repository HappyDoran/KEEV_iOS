//
//  FollowServiceProtocol.swift
//  KEEV
//
//  Created by 김준성 on 3/20/25.
//

import Foundation

protocol FollowServiceProtocol {
    func follow(_ userID: Int) async throws -> FollowState
    func unfollow(_ userID: Int) async throws -> FollowState
    func checkFollowing(of userID: Int) async throws -> FollowState
    func count(of userID: Int, type: UserFollowType) async throws -> Int
    func userList(of userID: Int, type: UserFollowType, page: Int, size: Int) async throws -> PaginatedResponse<SimpleUserUIO>
    func myFollowingsVibes(page: Int, size: Int) async throws -> PaginatedResponse<VibeUIO>
}

enum UserFollowType {
    case follower
    case following
}

enum FollowState: Decodable {
    case following
    case notFollowing
    
    var toBoolean: Bool {
        switch self {
        case .following:
            return true
        case .notFollowing:
            return false
        }
    }
    
    enum CodingKeys: CodingKey {
        case isFollowing
    }
    
    init(_ boolean: Bool) {
        self = boolean ? .following : .notFollowing
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let isFollowing = try container.decode(Bool.self, forKey: .isFollowing)
        self = .init(isFollowing)
    }
}
