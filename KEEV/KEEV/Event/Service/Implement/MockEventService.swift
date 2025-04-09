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

    private let jsonDecoder: JSONDecoder = JSONDecoder()
    
    func loadPaginatedEvents(page: Int, size: Int, sort: [(SortCase, SortPattern)] = [(SortCase.createdDate, .descending)]) async throws -> PaginatedResponse<SimpleEventUIO> {
        var events: [SimpleEventUIO] = []
        let startIndex = page*size
        
        for index in startIndex..<startIndex + size {
            events.append(
                .init(id: index, name: "Dummy Title: 이벤트\(index)", posterURL: SimpleEventUIO.dummy0.posterURL, dDay: Int.random(in: -10...10), startDate: "2024.12.05", endDate: "2024.12.05", placeName: "공연장\(index)")
            )
        }
        
        return PaginatedResponse(totalPages: 5, currentPage: page, totalElements: 50, contents: events)
    }
    
    func loadPaginatedFilterThemeEvents(theme: FilterTheme, page: Int, size: Int, sort: [(SortCase, SortPattern)] = [(SortCase.createdDate, .descending)]) async throws -> PaginatedResponse<SimpleEventUIO> {
        var events: [SimpleEventUIO] = []
        let startIndex = page*size
        
        for index in startIndex..<startIndex + size {
            events.append(
                .init(id: index, name: "Dummy Title: 이벤트\(index)", posterURL: SimpleEventUIO.dummy0.posterURL, dDay: Int.random(in: -10...10), startDate: "2024.12.05", endDate: "2024.12.05", placeName: "공연장\(index)")
            )
        }
        
        return PaginatedResponse(totalPages: 5, currentPage: page, totalElements: 50, contents: events)
    }
    
    func loadDetailEvent(id: Int) async throws -> DetailEventUIO {
        .dummy0
    }
    
    func getEventLikeCount(id: Int) async throws -> Int {
        return 35
    }
    
    func getIsLikedEvent(id: Int) async throws -> Bool {
        return true
    }
    
    func addEventLike(id: Int) async throws -> Bool {
        return true
    }
    
    func deleteEventLike(id: Int) async throws -> Bool {
        return false
    }
}
