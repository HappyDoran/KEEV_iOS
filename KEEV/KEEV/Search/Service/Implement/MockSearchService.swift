//
//  MockSearchService.swift
//  KEEV
//
//  Created by Yune Cho on 11/30/24.
//

import Foundation

/// MockSearchService
///
/// 서버와의 통신 없이 UI가 잘 나오는지 확인하기 위한 MockSearchService입니다.
///
/// - Author: 라움
class MockSearchService: SearchServiceProtocol {
    private let userDefaultsUtility = UserDefaultsUtility()
    private var recentSearch: [RecentSearch] = [RecentSearch(term: "세상에서 제일 재밌는 공연", date: Date())]
    
    func setRecentSearch(searchItem: RecentSearch) {
        recentSearch.append(searchItem)
    }
    
    func getRecentSearch() -> [RecentSearch] {
        recentSearch
    }
    
    func removeRecentSearch(id: UUID) {
        recentSearch.removeAll(where: { $0.id == id })
    }
    
    func removeAllRecentSearch() {
        recentSearch.removeAll()
    }
    
    func searchEventByNameWhenAddVibe(name: String, size: Int, page: Int) async throws -> PaginatedResponse<SimpleEventUIO> {
        var contents: [SimpleEventUIO] = []
        let startIndex = page * size
        
        for index in startIndex..<startIndex + size {
            contents.append(
                .init(id: "dummyID: \(index)", name: "Dummy Title: 이벤트\(index)", posterURL: SimpleEventUIO.dummy0.posterURL, dDay: Int.random(in: -10...10), startDate: "2024.12.05", endDate: "2024.12.05", placeName: "공연장\(index)")
            )
        }
        
        return PaginatedResponse(totalPages: 5, currentPage: page, totalElements: 50, contents: contents)
    }
    
    func searchEventByName(name: String, size: Int, page: Int) async throws -> PaginatedResponse<SimpleEventUIO> {
        var contents: [SimpleEventUIO] = []
        let startIndex = page * size
        
        for index in startIndex..<startIndex + size {
            contents.append(
                .init(id: "dummyID: \(index)", name: "Dummy Title: 이벤트\(index)", posterURL: SimpleEventUIO.dummy0.posterURL, dDay: Int.random(in: -10...10), startDate: "2024.12.05", endDate: "2024.12.05", placeName: "공연장\(index)")
            )
        }
        
        return PaginatedResponse(totalPages: 5, currentPage: page, totalElements: 50, contents: contents)
    }
}
