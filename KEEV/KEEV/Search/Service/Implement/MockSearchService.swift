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
    
    func setRecentSearch(newSearch: RecentSearch) throws {
        var recentSearch = try getRecentSearch()
        recentSearch.append(newSearch)
        try userDefaultsUtility.set(recentSearch, forKey: "recentSearch")
    }
    
    func getRecentSearch() throws -> [RecentSearch] {
        guard let recentSearch = try userDefaultsUtility.get([RecentSearch].self, forKey: "recentSearch") else { return [] }
        
        return recentSearch
    }
    
    func deleteRecentSearch(id: UUID) throws {
        var recentSearch = try getRecentSearch()
        recentSearch.removeAll(where: { $0.id == id })
        try userDefaultsUtility.set(recentSearch, forKey: "recentSearch")
    }
    
    func searchEventByNameWhenAddVibe(name: String) async throws -> [SimpleEventUIO] {
        SimpleEventUIO.dummies.filter { $0.name.contains(name) }
    }
    
    func searchEventByName(name: String) async throws -> [SimpleEventUIO] {
        SimpleEventUIO.dummies.filter { $0.name.contains(name) }
    }
}
