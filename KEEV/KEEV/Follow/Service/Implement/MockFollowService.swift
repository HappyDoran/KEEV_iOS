//
//  MockFollowService.swift
//  KEEV
//
//  Created by 김준성 on 3/24/25.
//

import Foundation

final class MockFollowService: FollowServiceProtocol {
    private let dummyUsers: [SimpleUserUIO] = [.dummy0, .dummy1, .dummy2]
    
    func follow(_ userID: Int) async throws -> FollowState {
        .following
    }
    
    func unfollow(_ userID: Int) async throws -> FollowState {
        .notFollowing
    }
    
    func checkFollowing(of userID: Int) async throws -> FollowState {
        .notFollowing
    }
    
    func count(of userID: Int, type: UserFollowType) async throws -> Int {
        switch type {
        case .follower:
            return 108
        case .following:
            return 2387
        }
    }
    
    func userList(of userID: Int, type: UserFollowType, page: Int, size: Int) async throws -> PaginatedResponse<SimpleUserUIO> {
        var users: [SimpleUserUIO] = []
        for id in rangeOfIndex(page: page, size: size) {
            users.append(.init(id: id, nickname: "\(type)mockUser\(id)", profileImageURL: nil))
        }
        
        return PaginatedResponse(totalPages: size*10, currentPage: page, totalElements: 10, contents: users)
    }
    
    func myFollowingsVibes(page: Int, size: Int) async throws -> PaginatedResponse<VibeUIO> {
        var vibes: [VibeUIO] = []
        for id in rangeOfIndex(page: page, size: size) {
            vibes.append(.init(id: id, user: dummyUsers[id % dummyUsers.count], event: .dummies.randomElement()!, rating: 2.5, imageURLs: [], comment: "mockFollowingVibesComment\(id)", createdDate: "2023-03-05T00:00:00.222222", likeCount: 19, replyCount: 28, isMine: false))
        }
        
        return PaginatedResponse(totalPages: size*10, currentPage: page, totalElements: 10, contents: vibes)
    }
    
    private func rangeOfIndex(page: Int, size: Int) -> Range<Int> {
        let minimumID = page * size
        let maximumID = (page + 1) * size
        return (minimumID..<maximumID)
    }
}
