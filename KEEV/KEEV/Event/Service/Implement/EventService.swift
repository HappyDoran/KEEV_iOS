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
class EventService: TempEventServiceProtocol {
    
    private let networkUtility: NetworkUtility = NetworkUtility()
    
    func loadPaginatedEvents(page: Int, size: Int, sort: String = "createdDate:desc") async throws -> PaginatedResponse<SimpleEventUIO> {
        let sortParameters: [SortParameter] = sort.split(separator: ",").map {
            let components = $0.split(separator: ":").map(String.init)
            return (key: components[0], value: components.count > 1 ? components[1] : "asc") 
        }

        let router = EventHTTPRequestRouter.fetchEvents(page: page, size: size, sort: sortParameters)

        let (_, data) = try await networkUtility.requestWithStatusCode(router: router)

        
        print(data)
        
        let paginatedResponseDTO = try JSONDecoder().decode(PaginationDTO<SimpleEventDTO>.self, from: data)

        let contents = paginatedResponseDTO.contents.map { SimpleEventUIO(simpleEventDTO: $0) }

        let paginatedResponse = PaginatedResponse<SimpleEventUIO>(
            totalPages: paginatedResponseDTO.totalElements,
            currentPage: paginatedResponseDTO.currentPage,
            totalElements: paginatedResponseDTO.totalPages,
            contents: contents
        )

        return paginatedResponse
    }
    
//    func loadDetailEvent(id: String) async throws -> DetailEventUIO {
//        <#code#>
//    }
}
