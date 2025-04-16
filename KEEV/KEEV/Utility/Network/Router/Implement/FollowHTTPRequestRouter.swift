//
//  FollowHTTPRequestRouter.swift
//  KEEV
//
//  Created by 김준성 on 3/20/25.
//

import Foundation

enum FollowHTTPRequestRouter {
    case follow(token: String, userID: Int)
    case unfollow(token: String, userID: Int)
    case checkFollow(token: String, userID: Int)
    case myFollowingUserList(token: String, page: Int, size: Int)
    case myFollowerUserList(token: String, page: Int, size: Int)
    case followingUserList(userID: Int, page: Int, size: Int)
    case followerUserList(userID: Int, page: Int, size: Int)
    case followersCount(userID: Int)
    case followingsCount(userID: Int)
    case followingsVibeList(token: String)
    
    private var userIDString: String {
        switch self {
        case .follow(_, let userID):
            fallthrough
        case .unfollow(_, let userID):
            fallthrough
        case .checkFollow(_, let userID):
            fallthrough
        case .followingUserList(let userID, _, _):
            fallthrough
        case .followerUserList(let userID, _, _):
            fallthrough
        case .followersCount(let userID):
            fallthrough
        case .followingsCount(let userID):
            return String(userID)
        case .followingsVibeList: fatalError("팔로우한 유저의 컨텐츠 조회에는 userID가 없습니다.")
        case .myFollowingUserList, .myFollowerUserList: fatalError("유저의 팔로우, 팔로워 조회에는 userID가 없습니다.")
        }
    }
}

extension FollowHTTPRequestRouter: HTTPRequestable {
    var baseURL: any URLBaseComposable {
        AppEnvironment.keevBaseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .follow: .post
        case .unfollow: .delete
        case .checkFollow: .get
        case .followingUserList
            , .followerUserList
            , .followingsCount
            , .followersCount
            , .followingsVibeList
            , .myFollowingUserList
            , .myFollowerUserList: .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .follow(let token, _)
            , .unfollow(let token, _)
            , .checkFollow(let token, _)
            , .followingsVibeList(let token)
            , .myFollowingUserList(let token, _, _)
            , .myFollowerUserList(let token, _, _): ["Authorization": "Bearer " + token]
        case .followingUserList
            , .followerUserList
            , .followingsCount
            , .followersCount: nil
        }
    }
    
    var body: Data? {
        nil
    }
    
    var path: [String]? {
        switch self {
        case .follow
            , .unfollow
            , .checkFollow: ["api", "user", "follow", userIDString]
        case .myFollowingUserList: ["api", "user", "following"]
        case .myFollowerUserList: ["api", "user", "follower"]
        case .followingUserList: ["open-api", "user", userIDString, "following"]
        case .followerUserList: ["open-api", "user", userIDString, "follower"]
        case .followingsCount: ["open-api", "user", userIDString, "following", "count"]
        case .followersCount: ["open-api", "user", userIDString, "follower", "count"]
        case .followingsVibeList: ["open-api", "user", "following", "vibe"]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .followingUserList(_, let page, let size)
            , .followerUserList(_, let page, let size)
            , .myFollowingUserList(_, let page, let size)
            , .myFollowerUserList(_, let page, let size)
            : [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "size", value: "\(size)")
            ]
        default: nil
        }
    }
}
