//
//  FollowServiceProtocol.swift
//  KEEV
//
//  Created by 김준성 on 3/20/25.
//

import Foundation

protocol FollowServiceProtocol {
    func follow(_ userID: Int) async throws
    func unfollow(_ userID: Int) async throws
    func checkFollowing(of userID: Int) async throws -> Bool
    func count(of userID: Int, type: UserFollowType) async throws -> Int
    func userList(of userID: Int, type: UserFollowType, page: Int, size: Int) async throws -> PaginatedResponse<SimpleUserUIO>
    func myFollowingsVibes(page: Int, size: Int) async throws -> PaginatedResponse<VibeUIO>
}

enum UserFollowType {
    case follower
    case following
}
