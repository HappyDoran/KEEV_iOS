//
//  EventService.swift
//  KEEV
//
//  Created by Doran on 10/19/24.
//

import SwiftUI
import Observation

enum SortPattern: String {
    case ascending = "asc"
    case descending = "desc"
}

enum SortCase: String {
    case createdDate
    case startDate
    case interestCount

    func sortCase(with order: SortPattern) -> (key: String, value: String) {
        return (key: self.rawValue, value: order.rawValue)
    }
}

/// EventService는 이벤트와 관련된 비즈니스 로직을 구현한 클래스
///
/// - Author: Doran
class EventService: EventServiceProtocol {
    
    private let networkUtility: NetworkUtility = NetworkUtility()
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    
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
    /// - Author: Doran
    func loadPaginatedEvents(page: Int, size: Int, sort: [(SortCase, SortPattern)] = [(SortCase.createdDate, .descending)]) async throws -> PaginatedResponse<SimpleEventUIO> {
        let sortCases: [SortCase] = sort.map { $0.0 }
        let sortPatterns: [SortPattern] = sort.map { $0.1 }
        
        let router = EventHTTPRequestRouter.fetchEvents(page: page, size: size, sort: zip(sortCases, sortPatterns).map { $0.0.sortCase(with: $0.1) })
        
        let (_, data) = try await networkUtility.requestWithStatusCode(router: router)

        let paginatedResponseDTO = try jsonDecoder.decode(PaginationDTO<SimpleEventDTO>.self, from: data)

        let contents = paginatedResponseDTO.contents.map { SimpleEventUIO(simpleEventDTO: $0) }

        let paginatedResponse = PaginatedResponse<SimpleEventUIO>(
            totalPages: paginatedResponseDTO.totalElements,
            currentPage: paginatedResponseDTO.currentPage,
            totalElements: paginatedResponseDTO.totalPages,
            contents: contents
        )

        return paginatedResponse
    }

    
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
    /// - Author: Doran
    func loadDetailEvent(id: String) async throws -> DetailEventUIO {
        let router = EventHTTPRequestRouter.fetchDetailEvent(eventID: id)
        
        let (_, data) = try await networkUtility.requestWithStatusCode(router: router)
        
        let detailEventDTO = try jsonDecoder.decode(DetailEventDTO.self, from: data)
        let detailEventUIO = DetailEventUIO(detailEventDTO: detailEventDTO)
        
        return detailEventUIO
    }
}
