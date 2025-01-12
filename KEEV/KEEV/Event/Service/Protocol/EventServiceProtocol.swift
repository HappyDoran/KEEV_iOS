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
    func loadDetailEvent(id: String) async throws -> DetailEventUIO
    
    /// 필터링된 이벤트를 가져오는 함수
    ///
    /// - Parameters:
    ///   - page: 가져오고자하는 페이지의 번호
    ///   - size: 한 페이지에 넣을 이벤트의 갯수
    ///   - eventTypeID: 이벤트 타입 아이디
    ///   - genreID: 이벤트 장르 아이디
    ///   - startDate: 이벤트 시작 날짜
    ///   - eventDate: 이벤트 종료 날짜
    ///   - mode: 이벤트 or 예약일
    ///   - desc: 내림차순 여부
    ///
    /// 인자로 받은 파라미터로 필터링 된 이벤트를 가져옵니다.
    ///
    /// - Throws: 에러
    /// - Returns: 페이지네이션이 적용된 이벤트 목록
    ///
    /// - Author: Doran
    func loadPaginatedFilteredEvents(page: Int, size: Int, eventTypeID: Int?, genreID: Int?, startDate: String?, endDate: String?, mode: String, desc: Bool) async throws -> PaginatedResponse<SimpleEventUIO>
    
    /// 필터링된 이벤트를 가져오는 함수
    ///
    /// - Parameters:
    ///   - filter: 페이지 넘버,
    ///    이벤트의 갯수,
    ///    이벤트 타입,
    ///    이벤트 장르,
    ///    이벤트 시작일,
    ///    이벤트 종료일,
    ///    이벤트 모드,
    ///    이벤트 정렬을 프로퍼티로 가지는 구조체
    ///
    ///  인자로 받은 구조체 파라미터로 필터링 된 이벤트를 가져옵니다.
    ///
    /// - Throws: 에러
    /// - Returns: 페이지네이션이 적용된 이벤트 목록
    ///
    /// - Author: Doran
    func loadPaginatedFilteringEvents(filter: EventFilter) async throws -> PaginatedResponse<SimpleEventUIO>
}
