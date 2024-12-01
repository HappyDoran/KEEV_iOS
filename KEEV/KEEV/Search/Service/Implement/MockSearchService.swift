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
    private var dummyRecentSearch: [RecentSearch] = []
    
    func setRecentSearch(newSearch: RecentSearch) throws {
        dummyRecentSearch.append(newSearch)
    }
    
    func getRecentSearch() throws -> [RecentSearch] {
        return dummyRecentSearch
    }
    
    func deleteRecentSearch(id: UUID) throws {
        dummyRecentSearch.removeAll(where: { $0.id == id })
    }
    
    func searchEventByNameWhenAddVibe(name: String) async throws -> [SimpleEventUIO] {
        SimpleEventUIO.dummies.filter { $0.name.contains(name) }
    }
    
    func searchEventByName(name: String) async throws -> [SimpleEventUIO] {
        SimpleEventUIO.dummies.filter { $0.name.contains(name) }
    }
}
