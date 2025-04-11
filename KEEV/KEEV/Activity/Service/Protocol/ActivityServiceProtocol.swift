//
//  ActivityServiceProtocol.swift
//  KEEV
//
//  Created by Yune Cho on 11/26/24.
//

import Foundation
import UIKit

/// ActivityService를 구현하기 위한 프로토콜
///
/// ActivityService를 구현하기 위한 프로토콜입니다.
///
/// - Author: 라움
protocol ActivityServiceProtocol: LayerRepresentable, AnyObject {
    /// 사용자 ID를 통한 회원 정보 조회 함수
    ///
    /// - Parameters:
    ///   - userID: 사용자 ID
    ///
    /// 사용자 ID를 통해 회원 정보를 조회할 수 있는 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 상세 유저 정보
    ///
    /// - Author: 라움
    func getUserInfo(userID: Int) async throws -> DetailUserUIO
    
    /// 회원가입 정보를 넣는 함수.
    ///
    /// - Parameters:
    ///   - nickname: 유저가 쓸 닉네임 입니다.
    ///   - profileImage: 프로필 사진이며 사용자가 사진을 넣지 않았을 경우, `nil`을 넣으면 됩니다..
    ///   - backgroundImage: 프로필의 배경화면이며 사용자가 배경화면을 넣지 않았을 경우, `nil`을 넣으면 됩니다.
    ///   - description: 한 줄 소개이며, 빈 값일 경우 `nil`을 넣으면 됩니다.
    ///
    /// 회원 정보를 서버로 넘겨 회원가입을 진행합니다.
    ///
    /// - Throws: 닉네임이 정해진 형식을 지키지 않았거나 서버에 중복된 이메일 또는 닉네임이 있을 때, 그리고 서버와 통신을 실패했을 때 에러를 던집니다.
    /// - Returns: 회원정보가 서버에서 변경이 된다면 그 값을 `DetailUserUIO`로 다시 리턴받습니다.
    /// - Author: newJunsung
    func updateProfile(
        nickname: String,
        profileImage: UIImage?,
        backgroundImage: UIImage?,
        description: String
    ) async throws -> DetailUserUIO
    
    /// 사용자의 바이브 목록을 가져오는 함수
    ///
    /// - Parameters:
    ///   - userID: 사용자 ID
    ///
    /// 사용자 ID를 받아서 해당 사용자가 작성한 바이브 목록을 가져오는 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 사용자의 바이브 목록
    ///
    /// - Author: 라움
    func getUserVibeList(userID: Int) async throws -> [VibeUIO]
    
    /// 관심 이벤트 목록을 가져오는 함수
    ///
    /// - Parameters:
    ///   - page: 가져오고자하는 페이지의 번호
    ///   - size: 한 페이지에 넣을 이벤트의 갯수
    ///   - sort: 이벤트 정렬 기준
    ///
    /// 페이지네이션이 적용된 관심 이벤트 목록을 가져오는 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 페이지네이션이 적용된 관심 이벤트 목록
    ///
    /// - Author: newJunsung
    func getUserLikedEvents(userID: Int, page: Int, size: Int, sort: [(SortCase, SortPattern)]) async throws -> PaginatedResponse<SimpleEventUIO>
    
    
    func follow(_ userID: Int) async throws -> FollowState
    func unfollow(_ userID: Int) async throws -> FollowState
    func checkFollowing(of userID: Int) async throws -> FollowState
    func count(of userID: Int, type: UserFollowType) async throws -> Int
    func userList(of userID: Int, type: UserFollowType, page: Int, size: Int) async throws -> PaginatedResponse<UserFollowUIO>
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
