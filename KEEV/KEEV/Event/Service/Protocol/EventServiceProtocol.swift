//
//  TempEventServiceProtocol.swift
//  KEEV
//
//  Created by Yune Cho on 11/22/24.
//

import Foundation

/// EventService를 구현하기 위한 프로토콜
///
/// EventService를 구현하기 위한 프로토콜입니다.
///
/// - ToDo: 향후에 EventServiceProtocol을 이 TempEventServiceProtocol로 교체해야합니다.
/// - Author: 라움
protocol EventServiceProtocol: LayerRepresentable, AnyObject {
    /// 이벤트 목록을 가져오는 함수
    ///
    /// - Parameters:
    ///   - page: 가져오고자하는 페이지의 번호
    ///   - size: 한 페이지에 넣을 이벤트의 갯수
    ///   - sort: 이벤트 정렬 기준
    ///
    /// 페이지네이션이 적용된 이벤트 목록을 가져오는 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 페이지네이션이 적용된 이벤트 목록
    ///
    /// - Author: 라움
    func loadPaginatedEvents(page: Int, size: Int, sort: [(SortCase, SortPattern)]) async throws -> PaginatedResponse<SimpleEventUIO>
    
    /// 필터링된 이벤트를 가져오는 함수
    ///
    /// - Parameters:
    ///   - theme: 필터링 테마
    ///   - page: 가져오고자하는 페이지의 번호
    ///   - size: 한 페이지에 넣을 이벤트의 갯수
    ///   - sort: 이벤트 정렬 기준
    ///
    ///  인자로 받은 파라미터로 필터링 된 이벤트를 가져옵니다.
    ///
    /// - Throws: 에러
    /// - Returns: 페이지네이션이 적용된 이벤트 목록
    ///
    /// - Author: Doran
    func loadPaginatedFilterThemeEvents(theme: FilterTheme, page: Int, size: Int, sort: [(SortCase, SortPattern)]) async throws -> PaginatedResponse<SimpleEventUIO>
    
    /// 이벤트 ID에 해당하는 이벤트 상세정보를 가져오는 함수
    ///
    /// - Parameters:
    ///   - id: 이벤트 ID
    ///
    /// 인자로 받은 이벤트 ID에 해당하는 이벤트 상세정보를 가져오는 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 이벤트 상세정보 UIO
    ///
    /// - Author: 라움
    func loadDetailEvent(id: Int) async throws -> DetailEventUIO
    
    /// 이벤트 ID에 해당하는 이벤트의 좋아요 갯수를 가져오는 함수
    ///
    /// - Parameters:
    ///   - id: 이벤트 ID
    ///
    /// 인자로 받은 이벤트 ID에 해당하는 이벤트의 좋아요 갯수를 가져오는 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 좋아요 갯수
    ///
    /// - Author: Doran
    func getEventLikeCount(id: Int) async throws -> Int
    
    /// 이벤트 ID에 해당하는 이벤트를 사용자가 이전에 좋아요를 했었는지 아닌지를 가져오는 함수
    ///
    /// - Parameters:
    ///   - id: 이벤트 ID
    ///
    /// 인자로 받은 ID에 해당하는 이벤트의 사용자의 이전 좋아요 여부를 가져오는 함수힙니다.
    ///
    /// - Throws: 에러
    /// - Returns: 좋아요 여부
    ///
    /// - Author: Doran
    func getIsLikedEvent(id: Int) async throws -> Bool
    
    /// 이벤트 ID에 해당하는 이벤트에 사용자가 좋아요를 눌러서 관심표시로 바꾸는 함수
    ///
    /// - Parameters:
    ///   - id: 이벤트 ID
    ///
    /// 인자로 받은 이벤트 ID에 해당하는 이벤트의 좋아요를 사용자가 눌러서 관심표시로 바꾸는  함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 좋아요가 잘 추가되면 true를 반환
    ///
    /// - Author: Doran
    func addEventLike(id: Int) async throws -> Bool
    
    /// 이벤트 ID에 해당하는 이벤트에 사용자가 좋아요를 눌러서 관심 해제하는 함수
    ///
    /// - Parameters:
    ///   - id: 이벤트 ID
    ///
    /// 인자로 받은 이벤트 ID에 해당하는 이벤트의 좋아요를 사용자가 눌러서 관심표시를 해제하는 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 좋아요가 잘 해제됐으면 false를 반환
    ///
    /// - Author: Doran
    func deleteEventLike(id: Int) async throws -> Bool
}
