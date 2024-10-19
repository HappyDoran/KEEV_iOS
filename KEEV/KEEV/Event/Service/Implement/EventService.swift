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
/// 이벤트 데이터를 가져오거나, 특정 이벤트를 검색하여 가져오는 기능을 제공합니다.
///
/// - Note: 싱글톤 패턴으로 구현 가능하며 이를 통해 전역 인스턴스로 공유할 수 있습니다.
///
/// - Author: Doran
class EventService: ObservableObject {
    private let networkUtility: NetworkUtility = NetworkUtility()
    
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
    func loadEvents(startDate: String, endDate: String, page: String, rows: String) async throws -> [ConcertDTO] {
        /// getEvent router 생성
        let router = EventRouter.getEvents(
            stdate: startDate,
            eddate: endDate,
            cpage: page,
            rows: rows
        )
        
        /// 비동기 통신
        do {
            let data: Data = try await networkUtility.xmlRequest(router: router)
            
            let parser = EventXMLParser()
            let events = parser.parse(data)
            
            return events
        } catch {
            print("\(error)")
            throw error
        }
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
    func loadEventByKeyword(startDate: String, endDate: String, keyword: String, page: String, rows: String) async throws -> [ConcertDTO] {
        let router = EventRouter.getEventByKeyword(
            stdate: startDate,
            eddate: endDate,
            keyword: keyword,
            cpage: page,
            rows: rows
        )
        
        do {
            let data: Data = try await networkUtility.xmlRequest(router: router)
            
            let parser = EventXMLParser()
            let events = parser.parse(data)
            
            return events
        } catch {
            print("\(error)")
            throw error
        }
    }
}
