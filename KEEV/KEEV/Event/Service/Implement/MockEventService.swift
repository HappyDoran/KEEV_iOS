//
//  MockEventService.swift
//  KEEV
//
//  Created by Yune Cho on 11/23/24.
//

import Foundation

/// MockEventService
///
/// 서버와의 통신 없이 UI가 잘 나오는지 확인하기 위한 MockEventService입니다.
///
/// - Todo: 향후에 EventService와 EventServiceProtocol을 교체하면서 MockService의 프로토콜도 수정해주어야합니다.
/// - Author: 라움, Doran
class MockEventService: EventServiceProtocol, KEEVErrorHandler {
    typealias Layer = MockEventService
    
    static let layer: LayerType = .service(of: "MockEventService")
    
    private let networkUtility: NetworkUtility = NetworkUtility()
    private let tokenUtility = TokenUtility.shared
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    
    func loadPaginatedEvents(page: Int, size: Int, sort: [(SortCase, SortPattern)] = [(SortCase.createdDate, .descending)]) async throws -> PaginatedResponse<SimpleEventUIO> {
        var events: [SimpleEventUIO] = []
        let startIndex = page*size
        
        for index in startIndex..<startIndex + size {
            events.append(
                .init(id: "dummyID: \(index)", name: "Dummy Title: 이벤트\(index)", posterURL: SimpleEventUIO.dummy0.posterURL, dDay: Int.random(in: -10...10), startDate: "2024.12.05", endDate: "2024.12.05", placeName: "공연장\(index)")
            )
        }
        
        return PaginatedResponse(totalPages: 5, currentPage: page, totalElements: 50, contents: events)
    }
    
    func loadDetailEvent(id: String) async throws -> DetailEventUIO {
        .dummy0
    }
    
    func getEventLikeCount(id: String) async throws -> Int {
        let router = EventHTTPRequestRouter.fetchEventLikeCount(eventID: "85ef3d7a-21e3-449b-b49c-e5b5d3861912")
        
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
    
    func addEventLike(id: String) async throws -> Bool {
        try await doAsyncWithException(caller: "addEventLike"){
            let accessToken = try await getAccessToken()
            let router = EventHTTPRequestRouter.addEventLike(token: accessToken, eventID: id)
            
            let data = try await networkUtility.request(router: router)
            
            let eventLikeResponse = try jsonDecoder.decode(EventLikeResponse.self, from: data)
            
            return eventLikeResponse.isInterested
        }
    }
    
    func deleteEventLike(id: String) async throws -> Bool {
        try await doAsyncWithException(caller: "deleteEventLike"){
            let accessToken = try await getAccessToken()
            let router = EventHTTPRequestRouter.deleteEventLike(token: accessToken, eventID: id)
            
            let data = try await networkUtility.request(router: router)
            
            let eventLikeResponse = try jsonDecoder.decode(EventLikeResponse.self, from: data)
            
            return eventLikeResponse.isInterested
        }
    }
    
    func loadPaginatedFilteredEvents(page: Int = 0, size: Int = 10, eventTypeID: Int? = nil, genreID: Int? = nil, startDate: String? = nil, endDate: String? = nil, mode: String = "event", desc: Bool = true) async throws -> PaginatedResponse<SimpleEventUIO> {
        var events: [SimpleEventUIO] = []
        let startIndex = page*size
        
        for index in startIndex..<startIndex + size {
            events.append(
                .init(id: "dummyID: \(index)", name: "Dummy Title: 이벤트\(index)", posterURL: SimpleEventUIO.dummy0.posterURL, dDay: Int.random(in: -10...10), startDate: "2024.12.05", endDate: "2024.12.05", placeName: "공연장\(index)")
            )
        }
        
        return PaginatedResponse(totalPages: 5, currentPage: page, totalElements: 50, contents: events)
    }
    
    
    func loadPaginatedFilteringEvents(filter: EventFilter) async throws -> PaginatedResponse<SimpleEventUIO> {
        var events: [SimpleEventUIO] = []
        let startIndex = filter.page*filter.size
        
        for index in startIndex..<startIndex + filter.size {
            events.append(
                .init(id: "dummyID: \(index)", name: "Dummy Title: 이벤트\(index)", posterURL: SimpleEventUIO.dummy0.posterURL, dDay: Int.random(in: -10...10), startDate: "2024.12.05", endDate: "2024.12.05", placeName: "공연장\(index)")
            )
        }
        
        return PaginatedResponse(totalPages: 5, currentPage: filter.page, totalElements: 50, contents: events)
    }
}

extension MockEventService {
    private func getAccessToken() async throws -> String {
        try await tokenUtility.fetchToken(for: .access)
    }
}
