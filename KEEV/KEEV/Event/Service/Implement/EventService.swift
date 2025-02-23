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
class EventService: EventServiceProtocol, KEEVErrorHandler {
    typealias Layer = EventService
    
    static let layer: LayerType = .service(of: "EventService")
    
    private let networkUtility: NetworkUtility = NetworkUtility()
    private let tokenUtility = TokenUtility.shared
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
        
        let (code, data) = try await networkUtility.requestWithStatusCode(router: router)
        
        guard (200..<300).contains(code) else {
            let errorMessage = try jsonDecoder.decode(ErrorMessageDTO.self, from: data)
            throw throwKEEVError(
                caller: "loadPaginatedEvents(page: Int, size: Int, sort: [(SortCase, SortPattern)])",
                occurPoint: .remote(code: code, message: errorMessage.message)
            )
        }
        
        return try doWithException(caller: "loadPaginatedEvents(page: Int, size: Int, sort: [(SortCase, SortPattern)])") {
            let paginatedResponseDTO = try jsonDecoder.decode(PaginationDTO<SimpleEventDTO>.self, from: data)
            
            let contents = paginatedResponseDTO.contents.map { SimpleEventUIO(simpleEventDTO: $0) }
            
            let paginatedResponse = PaginatedResponse<SimpleEventUIO>(
                totalPages: paginatedResponseDTO.totalPages,
                currentPage: paginatedResponseDTO.currentPage,
                totalElements: paginatedResponseDTO.totalElements,
                contents: contents
            )
            
            return paginatedResponse
        }
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
        
        let (code, data) = try await networkUtility.requestWithStatusCode(router: router)
        
        guard (200..<300).contains(code) else {
            let errorMessage = try jsonDecoder.decode(ErrorMessageDTO.self, from: data)
            throw throwKEEVError(
                caller: "loadDetailEvent",
                occurPoint: .remote(code: code, message: errorMessage.message)
            )
        }
        
        return try doWithException(caller: "loadDetailEvent") {
            let eventResponseDTO = try jsonDecoder.decode(EventResponseDTO.self, from: data)
            guard let detailEventDTO = eventResponseDTO.events.first else {
                throw throwKEEVError(caller: "loadDetailEvent", occurPoint: .local(description: "Event not found"))
            }
            
            let detailEventUIO = DetailEventUIO(detailEventDTO: detailEventDTO)
            
            return detailEventUIO
            
        }
    }
    
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
    /// - Author: 라움
    func loadLikedEvents(page: Int, size: Int, sort: [(SortCase, SortPattern)]) async throws -> PaginatedResponse<SimpleEventUIO> {
        let accessToken = try await getAccessToken()
        let router = EventHTTPRequestRouter.fetchLikedEvents(token: accessToken, page: page, size: size, sort: sort.map { $0.0.sortCase(with: $0.1) })
        
        let (code, data) = try await networkUtility.requestWithStatusCode(router: router)
        
        guard (200..<300).contains(code) else {
            let errorMessage = try jsonDecoder.decode(ErrorMessageDTO.self, from: data)
            throw throwKEEVError(
                caller: "loadLikedEvents(page: Int, size: Int, sort: [(SortCase, SortPattern)])",
                occurPoint: .remote(code: code, message: errorMessage.message)
            )
        }
        
        return try doWithException(caller: "loadLikedEvents(page: Int, size: Int, sort: [(SortCase, SortPattern)])") {
            let paginatedResponseDTO = try jsonDecoder.decode(PaginationDTO<LikedEventDTO>.self, from: data)
            
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
    func getEventLikeCount(id: String) async throws -> Int {
        let router = EventHTTPRequestRouter.fetchEventLikeCount(eventID: id)
        
        let (code, data) = try await networkUtility.requestWithStatusCode(router: router)
        
        guard (200..<300).contains(code) else {
            let errorMessage = try jsonDecoder.decode(ErrorMessageDTO.self, from: data)
            throw throwKEEVError(
                caller: "getEventLikeCount",
                occurPoint: .remote(code: code, message: errorMessage.message)
            )
        }
        
        return try doWithException(caller: "getEventLikeCount(id: String)") {
            let likeCount = try jsonDecoder.decode(EventLikeCount.self, from: data)
            return likeCount.count
        }
    }
    
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
    func getIsLikedEvent(id: String) async throws -> Bool {
        try await doAsyncWithException(caller: "getIsLikedEvent"){
            let accessToken = try await getAccessToken()
            let router = EventHTTPRequestRouter.fetchEventisLiked(token: accessToken, eventID: id)
            
            let data = try await networkUtility.request(router: router)
            
            let eventLikeResponse = try jsonDecoder.decode(EventLikeResponse.self, from: data)
            
            return eventLikeResponse.isInterested
        }
    }
    
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
    func addEventLike(id: String) async throws -> Bool {
        try await doAsyncWithException(caller: "addEventLike"){
            let accessToken = try await getAccessToken()
            let router = EventHTTPRequestRouter.addEventLike(token: accessToken, eventID: id)
            
            let data = try await networkUtility.request(router: router)
            
            let eventLikeResponse = try jsonDecoder.decode(EventLikeResponse.self, from: data)
            
            return eventLikeResponse.isInterested
        }
    }
    
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
    func deleteEventLike(id: String) async throws -> Bool {
        try await doAsyncWithException(caller: "deleteEventLike"){
            let accessToken = try await getAccessToken()
            let router = EventHTTPRequestRouter.deleteEventLike(token: accessToken, eventID: id)
            
            let data = try await networkUtility.request(router: router)
            
            let eventLikeResponse = try jsonDecoder.decode(EventLikeResponse.self, from: data)
            
            return eventLikeResponse.isInterested
        }
    }
    
    // 삭제 요망
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
    /// 페이지네이션이 적용된 필터링 된 이벤트 목록을 가져오는 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 페이지네이션이 적용된 이벤트 목록
    ///
    /// - Author: Doran
    func loadPaginatedFilteredEvents(page: Int = 0, size: Int = 10, eventTypeID: Int? = nil, genreID: Int? = nil, startDate: String? = nil, endDate: String? = nil, mode: String = "event", desc: Bool = true) async throws -> PaginatedResponse<SimpleEventUIO> {
        let router = EventHTTPRequestRouter.fetchFilteredEvents(size: size, page: page, eventTypeID: eventTypeID, genreID: genreID, startDate: startDate, endDate: endDate, mode: mode, desc: desc)
        
        return try await doAsyncWithException(caller: "loadPaginatedFilteredEvents") {
            let (code, data) = try await networkUtility.requestWithStatusCode(router: router)

            guard (200..<300).contains(code) else {
                let errorMessage = try jsonDecoder.decode(ErrorMessageDTO.self, from: data)
                throw throwKEEVError(
                    caller: "loadPaginatedFilteredEvents",
                    occurPoint: .remote(code: code, message: errorMessage.message)
                )
            }
            
            let paginatedResponseDTO = try jsonDecoder.decode(PaginationDTO<SimpleEventDTO>.self, from: data)
            
            let contents = paginatedResponseDTO.contents.map { SimpleEventUIO(simpleEventDTO: $0) }
            
            let paginatedResponse = PaginatedResponse<SimpleEventUIO>(
                totalPages: paginatedResponseDTO.totalPages,
                currentPage: paginatedResponseDTO.currentPage,
                totalElements: paginatedResponseDTO.totalElements,
                contents: contents
            )

            return paginatedResponse
        }
    }
    
    // 삭제 요망
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
    func loadPaginatedFilteringEvents(filter: EventFilter) async throws -> PaginatedResponse<SimpleEventUIO> {
        
        let router = EventHTTPRequestRouter.fetchFilteredEvents(size: filter.size, page: filter.page, eventTypeID: filter.eventType?.rawValue, genreID: filter.genre?.rawValue, startDate: filter.startDate, endDate: filter.endDate, mode: filter.mode.rawValue, desc: filter.desc)
        
        return try await doAsyncWithException(caller: "loadPaginatedFilteringEvents") {
            let (code, data) = try await networkUtility.requestWithStatusCode(router: router)

            guard (200..<300).contains(code) else {
                let errorMessage = try jsonDecoder.decode(ErrorMessageDTO.self, from: data)
                throw throwKEEVError(
                    caller: "loadPaginatedFilteringEvents",
                    occurPoint: .remote(code: code, message: errorMessage.message)
                )
            }
            
            let paginatedResponseDTO = try jsonDecoder.decode(PaginationDTO<SimpleEventDTO>.self, from: data)
            
            let contents = paginatedResponseDTO.contents.map { SimpleEventUIO(simpleEventDTO: $0) }
            
            let paginatedResponse = PaginatedResponse<SimpleEventUIO>(
                totalPages: paginatedResponseDTO.totalPages,
                currentPage: paginatedResponseDTO.currentPage,
                totalElements: paginatedResponseDTO.totalElements,
                contents: contents
            )

            return paginatedResponse
        }
    }
    
    func loadPaginatedFilterThemeEvents(theme: FilterTheme, page: Int, size: Int, sort: [(SortCase, SortPattern)] = [(SortCase.startDate, .descending)]) async throws -> PaginatedResponse<SimpleEventUIO> {
        let sortCases: [SortCase] = sort.map { $0.0 }
        let sortPatterns: [SortPattern] = sort.map { $0.1 }
        let accessToken = try await getAccessToken()
        
        let router = EventHTTPRequestRouter.fetchFilterThemeEvents(token: accessToken, theme: theme, page: page, size: size, sort: zip(sortCases, sortPatterns).map { $0.0.sortCase(with: $0.1) })
        
        let (code, data) = try await networkUtility.requestWithStatusCode(router: router)
        
        guard (200..<300).contains(code) else {
            let errorMessage = try jsonDecoder.decode(ErrorMessageDTO.self, from: data)
            throw throwKEEVError(
                caller: "loadPaginatedFilterThemeEvents(theme: FilterTheme, page: Int, size: Int, sort: [(SortCase, SortPattern)])",
                occurPoint: .remote(code: code, message: errorMessage.message)
            )
        }
        
        return try doWithException(caller: "loadPaginatedFilterThemeEvents(theme: FilterTheme, page: Int, size: Int, sort: [(SortCase, SortPattern)])") {
            let paginatedResponseDTO = try jsonDecoder.decode(PaginationDTO<SimpleEventDTO>.self, from: data)
            
            let contents = paginatedResponseDTO.contents.map { SimpleEventUIO(simpleEventDTO: $0) }
            
            let paginatedResponse = PaginatedResponse<SimpleEventUIO>(
                totalPages: paginatedResponseDTO.totalPages,
                currentPage: paginatedResponseDTO.currentPage,
                totalElements: paginatedResponseDTO.totalElements,
                contents: contents
            )
            
            return paginatedResponse
        }
    }
}

extension EventService {
    private func getAccessToken() async throws -> String {
        try await tokenUtility.fetchToken(for: .access)
    }
}
