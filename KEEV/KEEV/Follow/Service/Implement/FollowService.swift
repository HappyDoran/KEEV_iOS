//
//  FollowService.swift
//  KEEV
//
//  Created by 김준성 on 3/20/25.
//

import Combine
import Foundation

final class FollowService {
    private typealias Router = FollowHTTPRequestRouter
    private let networkUtility = NetworkUtility()
    private let tokenUtility = TokenUtility.shared
    private let decoder = JSONDecoder()
    private var user: DetailUserUIO?
    private var cancellables: Set<AnyCancellable> = []
    
    init(user: DetailUserUIO? = nil) {
        self.user = user
        NotificationCenter.Publisher.userInfoPublisher
            .sink { [weak self] user in
                self?.user = user
            }
            .store(in: &cancellables)
    }
}

extension FollowService: FollowServiceProtocol {
    func follow(_ userID: Int) async throws {
        let token = try await tokenUtility.fetchToken(for: .access)
        let router = Router.follow(token: token, userID: userID)
        _ = try await networkUtility.request(router: router)
    }
    
    func unfollow(_ userID: Int) async throws {
        let token = try await tokenUtility.fetchToken(for: .access)
        let router = Router.unfollow(token: token, userID: userID)
        _ = try await networkUtility.request(router: router)
    }
    
    func checkFollowing(of userID: Int) async throws -> Bool {
        let token = try await tokenUtility.fetchToken(for: .access)
        let router = Router.checkFollow(token: token, userID: userID)
        let data = try await networkUtility.request(router: router)
        let dto = try decoder.decode(IsFollowingDTO.self, from: data)
        return dto.isFollowing
    }
    
    func count(of userID: Int, type: UserFollowType) async throws -> Int {
        let router: Router
        switch type {
        case .following: router = .followingsCount(userID: userID)
        case .follower: router = .followersCount(userID: userID)
        }
        let data = try await networkUtility.request(router: router)
        let dto = try decoder.decode(CountDTO.self, from: data)
        return dto.count
    }
    
    func userList(of userID: Int, type: UserFollowType, page: Int, size: Int) async throws -> PaginatedResponse<SimpleUserUIO> {
        let router: Router
        
        switch type {
        case .follower: router = .followingUserList(userID: userID, page: page, size: size)
        case .following: router = .followingUserList(userID: userID, page: page, size: size)
        }
        
        let data = try await networkUtility.request(router: router)
        let dto = try decoder.decode(PaginationDTO<SimpleUserDTO>.self, from: data)
        
        return PaginatedResponse(
            totalPages: dto.totalPages,
            currentPage: dto.currentPage,
            totalElements: dto.totalElements,
            contents: dto.contents.map(SimpleUserUIO.init)
        )
    }
    
    func myFollowingsVibes(page: Int, size: Int) async throws -> PaginatedResponse<VibeUIO> {
        let token = try await tokenUtility.fetchToken(for: .access)
        let router = Router.followingsVibeList(token: token)
        let data = try await networkUtility.request(router: router)
        let dto = try decoder.decode(PaginationDTO<VibeDTO>.self, from: data)
        
        return PaginatedResponse(
            totalPages: dto.totalPages,
            currentPage: dto.currentPage,
            totalElements: dto.currentPage,
            contents: dto.contents.map { VibeUIO.init(vibeDTO: $0, isMine: false) }
        )
    }
    
}

extension FollowService {
    struct IsFollowingDTO: Decodable {
        let isFollowing: Bool
    }
    
    struct CountDTO: Decodable {
        let count: Int
    }
}
