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
class SearchService: SearchServiceProtocol, KEEVErrorHandler {
    typealias Layer = SearchService
    
    static let layer: LayerType = .service(of: "SearchService")
    
    private let userDefaultsUtility: UserDefaultsUtility = UserDefaultsUtility()
    private let networkUtility: NetworkUtility = NetworkUtility()
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    private var recentSearch: [RecentSearch] = []
    
    init() {
        loadRecentSearch()
    }
    
    private func loadRecentSearch() {
        do {
            recentSearch = try userDefaultsUtility.get([RecentSearch].self, forKey: "recentSearch") ?? []
        } catch {
            print("최근 검색어를 불러오는데 실패했습니다.")
        }
    }
    
    private func updateUserDefaults(recendSearch: [RecentSearch]) {
        do {
            try userDefaultsUtility.set(recentSearch, forKey: "recentSearch")
        } catch {
            print("최근 검색어를 업데이트하지 못했습니다.")
        }
    }
    
    func setRecentSearch(searchItem: RecentSearch) {
        if recentSearch.contains(where: { $0.term == searchItem.term }) {
            if let index = recentSearch.firstIndex(where: { $0.term == searchItem.term }) {
                recentSearch.remove(at: index)
            }
        }
        
        recentSearch.append(searchItem)
        
        updateUserDefaults(recendSearch: recentSearch)
    }
    
    func getRecentSearch() -> [RecentSearch] {
        recentSearch
    }
    
    func removeRecentSearch(id: UUID) {
        if let index = recentSearch.firstIndex(where: { $0.id == id }) {
            recentSearch.remove(at: index)
        }
        
        updateUserDefaults(recendSearch: recentSearch)
    }
    
    func removeAllRecentSearch() {
        recentSearch.removeAll()
        
        updateUserDefaults(recendSearch: recentSearch)
    }
    
    func searchEventByNameWhenAddVibe(name: String, size: Int, page: Int) async throws -> PaginatedResponse<SimpleEventUIO> {
        try await doAsyncWithException(caller: "searchEventByNameWhenAddVibe") {
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
    }
    
    func searchEventByName(name: String, size: Int, page: Int) async throws -> PaginatedResponse<SimpleEventUIO> {
        try await doAsyncWithException(caller: "searchEventByName") {
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
}
