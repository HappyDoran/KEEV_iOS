//
//  SearchServiceProtocol.swift
//  KEEV
//
//  Created by Yune Cho on 11/30/24.
//

import Foundation

/// SearchService를 구현하기 위한 프로토콜
///
/// SearchService를 구현하기 위한 프로토콜입니다.
///
/// - Author: 라움
protocol SearchServiceProtocol: AnyObject {
    /// 최근 검색한 검색어를 저장하는 함수
    ///
    /// - Parameters:
    ///   - searchItem: 새로운 검색어
    ///
    /// 최근 검색한 검색어를 저장하는 함수입니다.
    ///
    /// - Author: 라움
    func setRecentSearch(searchItem: RecentSearch)
    
    /// 최근 검색한 검색어를 가져오는 함수
    ///
    /// 최근 검색한 검색어를 가져오는 함수입니다.
    ///
    /// - Returns: 최근 검색한 검색어의 배열
    ///
    /// - Author: 라움
    func getRecentSearch() -> [RecentSearch]
    
    /// 최근 검색한 검색어를 삭제하는 함수
    ///
    /// - Parameters:
    ///   - id: 삭제할 최근 검색한 검색어의 ID
    ///
    /// 최근 검색한 검색어를 삭제하는 함수입니다.
    ///
    /// - Author: 라움
    func removeRecentSearch(id: UUID)
    
    /// 최근 검색한 검색어를 모두 삭제하는 함수
    ///
    /// 최근 검색한 검색어를 모두 삭제하는 함수입니다.
    ///
    /// - Author: 라움
    func removeAllRecentSearch()
    
    /// 바이브를 추가할 때 이벤트 이름으로 검색하는 함수
    ///
    /// - Parameters:
    ///   - name: 이벤트 이름
    ///   - size: 한 페이지에 담길 이벤트 개수
    ///   - page: 페이지 번호
    ///
    /// 바이브를 추가할 때 이벤트 이름으로 검색하는 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 페이지네이션이 적용된 이벤트 목록
    ///
    /// - Note: 리턴 값에 검색결과 나온 이벤트의 총 개수인 count 값은 보류라고 써있어서 일단 넣지 않았습니다.
    ///
    /// - Author: 라움
    func searchEventByNameWhenAddVibe(name: String, size: Int, page: Int) async throws -> PaginatedResponse<SimpleEventUIO>
    
    /// 이벤트 이름으로 검색하는 함수
    ///
    /// - Parameters:
    ///   - name: 이벤트 이름
    ///   - size: 한 페이지에 담길 이벤트 개수
    ///   - page: 페이지 번호
    ///
    /// 이벤트 이름으로 검색하는 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 페이지네이션이 적용된 이벤트 목록
    ///
    /// - Note: 리턴 값에 검색결과 나온 이벤트의 총 개수인 count 값은 보류라고 써있어서 일단 넣지 않았습니다.
    ///
    /// - Author: 라움
    func searchEventByName(name: String, size: Int, page: Int) async throws -> PaginatedResponse<SimpleEventUIO>
}
