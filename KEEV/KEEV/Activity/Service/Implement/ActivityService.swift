//
//  ActivityService.swift
//  KEEV
//
//  Created by Yune Cho on 11/28/24.
//

import Combine
import Foundation
import UIKit

/// 사용자가 서비스를 사용하면서 수행한 액티비티를 위한 ActivityService
///
/// 사용자가 서비스를 사용하면서 수행한 액태비티를 위한 ActivityService입니다.
///
/// - Author: 라움
final class ActivityService: ActivityServiceProtocol, KEEVErrorHandler {
    typealias Layer = ActivityService
    
    static let layer: LayerType = .service(of: "ActivityService")
    
    private let networkUtility = NetworkUtility()
    private let tokenUtility = TokenUtility.shared
    private let jsonDecoder: JSONDecoder
    
    private var currentUser: DetailUserUIO? = nil
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.jsonDecoder = JSONDecoder()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        jsonDecoder.dateDecodingStrategy = .formatted(dateformatter)
        
        NotificationCenter.Publisher.userInfoPublisher
            .sink { [weak self] user in
                self?.currentUser = user
            }
            .store(in: &cancellables)
    }
    
    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
        cancellables.removeAll()
    }
    
    func getUserInfo(userID: Int) async throws -> DetailUserUIO {
        try await doAsyncWithException(caller: "getUserInfo") { [weak self] in
            guard let self else { throw KEEVError(layer: Self.layer, caller: "getUserInfo", occurPoint: .custom(message: "self is nil"), previousError: nil) }
            
            if let currentUser, currentUser.id == userID {
                return currentUser
            }
            
            let router = ActivityHTTPRequestRouter.userInfo(userID: userID)
            
            let data = try await self.networkUtility.request(router: router)
            
            let response = try self.jsonDecoder.decode(DetailUserDTO.self, from: data)
            
            let detailUserUIO = DetailUserUIO(detailuserDTO: response)
            
            return detailUserUIO
        }
    }
    
    func updateProfile(nickname: String, profileImage: UIImage?, backgroundImage: UIImage?, description: String) async throws -> DetailUserUIO {
        let accessToken = try await tokenUtility.fetchToken(for: .access)
        let userJSON = try JSONEncoder().encode(EditInfo(nickname: nickname, description: description))
        
        var builder = MultipartFormBuilder()
        builder.append(name: "editInfo", content: .json(data: userJSON))
        
        if let profileImage,
           let profileJPEG = profileImage.jpegData(compressionQuality: 0.5) {
            builder.append(name: "profileImage", fileName: UUID().uuidString, content: .jpeg(data: profileJPEG))
        }
        
        if let backgroundImage,
           let backgroundJPEG = backgroundImage.jpegData(compressionQuality: 0.7) {
            builder.append(name: "backgroundImage", fileName: UUID().uuidString, content: .jpeg(data: backgroundJPEG))
        }
        
        let (boundary, multipartData) = builder.build()!
        
        let router = AuthHTTPRequestRouter.modifyAccount(
            accessToken: accessToken,
            boundary: boundary,
            multipartData: multipartData
        )
        
        let data = try await networkUtility.request(router: router)
        let fetchedUser = try jsonDecoder.decode(DetailUserDTO.self, from: data)
        let uio = DetailUserUIO(detailuserDTO: fetchedUser)
        currentUser = uio
        return uio
    }
    
    func getUserVibeList(userID: Int) async throws -> [VibeUIO] {
        try await doAsyncWithException(caller: "getUserVibeList") { [weak self] in
            guard let self else { throw KEEVError(layer: Self.layer, caller: "getUserInfo", occurPoint: .custom(message: "self is nil"), previousError: nil) }
            
            let router = ActivityHTTPRequestRouter.userVibeList(userID: userID)
            
            let data = try await self.networkUtility.request(router: router)
            
            let response = try self.jsonDecoder.decode(PaginationDTO<VibeDTO>.self, from: data)
            
            if let currentUser {
                return response.contents.map { VibeUIO(vibeDTO: $0, isMine: $0.user.id == currentUser.id ? true : false) }
            } else {
                return response.contents.map { VibeUIO(vibeDTO: $0, isMine: false) }
            }
        }
    }
    
    func getUserLikedEvents(userID: Int, page: Int, size: Int, sort: [(SortCase, SortPattern)]) async throws -> PaginatedResponse<SimpleEventUIO> {
        let router = ActivityHTTPRequestRouter.userLikedEvents(userID: userID, page: page, size: size, sort: sort.map { $0.0.sortCase(with: $0.1) })
        
        let (code, data) = try await networkUtility.requestWithStatusCode(router: router)
        
        guard (200..<300).contains(code) else {
            let errorMessage = try jsonDecoder.decode(ErrorMessageDTO.self, from: data)
            throw throwKEEVError(
                caller: "loadLikedEvents(page: Int, size: Int, sort: [(SortCase, SortPattern)])",
                occurPoint: .remote(code: code, message: errorMessage.message)
            )
        }
        
        return try doWithException(caller: "loadLikedEvents(page: Int, size: Int, sort: [(SortCase, SortPattern)])") { [weak self] in
            guard let self else { throw KEEVError(layer: Self.layer, caller: "getUserInfo", occurPoint: .custom(message: "self is nil"), previousError: nil) }
            
            let paginatedResponseDTO = try self.jsonDecoder.decode(PaginationDTO<LikedEventDTO>.self, from: data)
            
            let contents = paginatedResponseDTO.contents.map { SimpleEventUIO(likedEventDTO: $0) }
            
            let paginatedResponse = PaginatedResponse<SimpleEventUIO>(
                totalPages: paginatedResponseDTO.totalPages,
                currentPage: paginatedResponseDTO.currentPage,
                totalElements: paginatedResponseDTO.totalElements,
                contents: contents
            )
            
            return paginatedResponse
        }
    }
    
    func follow(_ userID: Int) async throws -> FollowState {
        let token = try await tokenUtility.fetchToken(for: .access)
        let router = FollowHTTPRequestRouter.follow(token: token, userID: userID)
        let data = try await networkUtility.request(router: router)
        return try jsonDecoder.decode(FollowState.self, from: data)
    }
    
    func unfollow(_ userID: Int) async throws -> FollowState {
        let token = try await tokenUtility.fetchToken(for: .access)
        let router = FollowHTTPRequestRouter.unfollow(token: token, userID: userID)
        let data = try await networkUtility.request(router: router)
        return try jsonDecoder.decode(FollowState.self, from: data)
    }
    
    func checkFollowing(of userID: Int) async throws -> FollowState {
        let token = try await tokenUtility.fetchToken(for: .access)
        let router = FollowHTTPRequestRouter.checkFollow(token: token, userID: userID)
        let data = try await networkUtility.request(router: router)
        let followState = try jsonDecoder.decode(FollowState.self, from: data)
        return followState
    }
    
    func count(of userID: Int, type: UserFollowType) async throws -> Int {
        let router: FollowHTTPRequestRouter
        switch type {
        case .following: router = .followingsCount(userID: userID)
        case .follower: router = .followersCount(userID: userID)
        }
        let data = try await networkUtility.request(router: router)
        let dto = try jsonDecoder.decode(CountDTO.self, from: data)
        return dto.count
    }
    
    func myUserList(type: UserFollowType, page: Int, size: Int) async throws -> PaginatedResponse<UserFollowUIO> {
        let token = try await tokenUtility.fetchToken(for: .access)
        let router: FollowHTTPRequestRouter
        
        switch type {
        case .following: router = .myFollowingUserList(token: token, page: page, size: size)
        case .follower: router = .myFollowerUserList(token: token, page: page, size: size)
        }
        
        let data = try await networkUtility.request(router: router)
        let dto = try jsonDecoder.decode(PaginationDTO<UserFollowDTO>.self, from: data)
        
        return PaginatedResponse(
            totalPages: dto.totalPages,
            currentPage: dto.currentPage,
            totalElements: dto.totalElements,
            contents: dto.contents.map(UserFollowUIO.init)
        )
    }
    
    func userList(of userID: Int, type: UserFollowType, page: Int, size: Int) async throws -> PaginatedResponse<UserFollowUIO> {
        let router: FollowHTTPRequestRouter
        
        switch type {
        case .following: router = .followingUserList(userID: userID, page: page, size: size)
        case .follower: router = .followerUserList(userID: userID, page: page, size: size)
        }
        
        let data = try await networkUtility.request(router: router)
        let dto = try jsonDecoder.decode(PaginationDTO<UserFollowDTO>.self, from: data)
        
        return PaginatedResponse(
            totalPages: dto.totalPages,
            currentPage: dto.currentPage,
            totalElements: dto.totalElements,
            contents: dto.contents.map(UserFollowUIO.init)
        )
    }
}

private extension ActivityService {
    struct EditInfo: Encodable {
        let nickname: String
        let description: String
    }
    
    struct CountDTO: Decodable {
        let count: Int
    }
}
