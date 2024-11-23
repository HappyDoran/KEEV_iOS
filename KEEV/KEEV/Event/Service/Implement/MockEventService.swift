//
//  MockEventService.swift
//  KEEV
//
//  Created by Yune Cho on 11/23/24.
//

import Foundation

class MockEventService: TempEventServiceProtocol {
    func loadPaginatedEvents(page: Int, size: Int, sort: String) async throws -> PaginatedResponse<SimpleEventUIO> {
        var events: [SimpleEventUIO] = []
        let startIndex = page*size
        
        for index in startIndex..<startIndex + size {
            events.append(
                .init(id: "dummyID: \(index)", name: "Dummy Title: 이벤트\(index)", posterURL: nil, dDay: 7, startDate: "2024.12.05", endDate: "2024.12.05", placeName: "공연장\(index)")
            )
        }
        
        return PaginatedResponse(totalPages: 5, currentPage: page, totalElements: 50, contents: events)
    }
    
    func loadDetailEvent(id: String) async throws -> DetailEventUIO {
        .dummy0
    }
}
