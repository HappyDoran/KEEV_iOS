//
//  ActivityServiceProtocol.swift
//  KEEV
//
//  Created by Yune Cho on 11/26/24.
//

import Foundation

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
}
