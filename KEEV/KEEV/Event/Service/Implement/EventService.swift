//
//  EventService.swift
//  KEEV
//
//  Created by Doran on 10/19/24.
//

import SwiftUI
import Observation

/// EventService는 이벤트와 관련된 비즈니스 로직을 구현한 클래스
///
/// - Author: Doran
class EventService: ObservableObject {
    
    private let networkUtility: NetworkUtility = NetworkUtility()
    private let xmlParser: EventXMLParser = EventXMLParser()
    
    /// 주어진 날짜 범위와 페이지 정보를 사용하여 이벤트 목록을 비동기적으로 가져오는 함수
    ///
    /// - Parameters:
    ///   - startDate: 검색할 시작 날짜 ("yyyyMMdd").
    ///   - endDate: 검색할 종료 날짜 ( "yyyyMMdd").
    ///   - page: 요청할 페이지 번호.
    ///   - rows: 한 페이지에 표시할 이벤트 수.
    ///
    /// - Throws: error
    /// - Returns: 이벤트 목록 [ConcertDTO]
    ///
    /// - Author: Doran
    func loadEvents(startDate: Date, endDate: Date, page: Int, rows: Int) async throws -> [ConcertDTO] {
        /// getEvent router 생성
        let router = EventRouter.getEvents(
            stdate: startDate,
            eddate: endDate,
            cpage: page,
            rows: rows
        )
        
        /// 비동기 통신
        return try await loadEventsInternal(router: router)
    }
    
    /// 주어진 날짜 범위와 페이지 정보를 사용하여 이벤트 목록 중 keyword에 해당하는 이벤트들만  비동기적으로 가져오는 함수
    ///
    /// - Parameters:
    ///   - startDate: 검색할 시작 날짜 ("yyyyMMdd").
    ///   - endDate: 검색할 종료 날짜 ( "yyyyMMdd").
    ///   - keyword: 검색할 키워드
    ///   - page: 요청할 페이지 번호.
    ///   - rows: 한 페이지에 표시할 이벤트 수.
    ///
    /// - Throws: error
    /// - Returns: 이벤트 목록 [ConcertDTO]
    ///
    /// - Author: Doran
    func loadEventByKeyword(startDate: Date, endDate: Date, keyword: String, page: Int, rows: Int) async throws -> [ConcertDTO] {
        let router = EventRouter.getEventByKeyword(
            stdate: startDate,
            eddate: endDate,
            keyword: keyword,
            cpage: page,
            rows: rows
        )
        
        return try await loadEventsInternal(router: router)
    }
}

extension EventService {
    /// XML Data를 비동기적으로 가져오는 함수
    ///
    /// - Parameters:
    ///   - router: 이벤트를 가져오기 위한 요청을 구성하는 `EventRouter` 인스턴스
    ///
    ///  내부적으로 XML 요청과 파싱 로직을 분리하여 재사용성을 고려한 메소드 입니다.
    ///
    /// - Throws:
    ///   - `NetworkError`: 네트워크 요청 중 발생한 오류.
    ///   - `XMLParsingError`: XML 데이터 파싱 중 발생한 오류.
    ///
    /// - Returns: 이벤트 목록 [ConcertDTO]
    ///
    /// - Author: Doran
    private func loadEventsInternal(router: EventRouter) async throws -> [ConcertDTO] {
        let data: Data = try await networkUtility.xmlRequest(router: router)
        let events = xmlParser.parse(data)
        return events
    }
}
