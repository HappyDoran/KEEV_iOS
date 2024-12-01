//
//  SearchService.swift
//  KEEV
//
//  Created by Yune Cho on 12/1/24.
//

import Foundation

/// 검색과 관련된 기능들을 수행하는 SearchService
///
/// 검색과 관련된 기능들을 수행하는 SearchService입니다.
///
/// - Author: 라움
class SearchService: SearchServiceProtocol {
    private let userDefaultsUtility: UserDefaultsUtility = UserDefaultsUtility()
    private let networkUtility: NetworkUtility = NetworkUtility()
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    
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
        print(recentSearch)
        print("\(id)")
        if let index = recentSearch.firstIndex(where: { $0.id == id }) {
            recentSearch.remove(at: index)
        }
        print(recentSearch)
        try userDefaultsUtility.set(recentSearch, forKey: "recentSearch")
    }
    
    func searchEventByNameWhenAddVibe(name: String, size: Int, page: Int) async throws -> PaginatedResponse<SimpleEventUIO> {
        let router = SearchHTTPRequestRouter.searchEventByNameWhenAddVibe(name: name, size: size, page: page)
        
        let data = try await networkUtility.request(router: router)
        
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
    
    func searchEventByName(name: String, size: Int, page: Int) async throws -> PaginatedResponse<SimpleEventUIO> {
        let router = SearchHTTPRequestRouter.searchEventByName(name: name, size: size, page: page)
        
        let data = try await networkUtility.request(router: router)
        
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
