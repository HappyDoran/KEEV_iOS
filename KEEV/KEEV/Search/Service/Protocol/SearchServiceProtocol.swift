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
    ///   - newSearch: 새로운 검색어
    ///
    /// 최근 검색한 검색어를 저장하는 함수입니다.
    ///
    /// - Throws: 에러
    ///
    /// - Author: 라움
    func setRecentSearch(newSearch: RecentSearch) throws
    
    /// 최근 검색한 검색어를 가져오는 함수
    ///
    /// 최근 검색한 검색어를 가져오는 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 최근 검색한 검색어의 배열
    ///
    /// - Author: 라움
    func getRecentSearch() throws -> [RecentSearch]
    
    /// 최근 검색한 검색어를 삭제하는 함수
    ///
    /// - Parameters:
    ///   - id: 삭제할 최근 검색한 검색어의 ID
    ///
    /// 최근 검색한 검색어를 삭제하는 함수입니다.
    ///
    /// - Throws: 에러
    ///
    /// - Author: 라움
    func deleteRecentSearch(id: UUID) throws
    
    /// 바이브를 추가할 때 이벤트 이름으로 검색하는 함수
    ///
    /// - Parameters:
    ///   - name: 이벤트 이름
    ///
    /// 바이브를 추가할 때 이벤트 이름으로 검색하는 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 간단한 이벤트 정보가 담긴 UIO의 배열
    ///
    /// - Note: 리턴 값에 검색결과 나온 이벤트의 총 개수인 count 값은 보류라고 써있어서 일단 넣지 않았습니다.
    ///
    /// - Author: 라움
    func searchEventByNameWhenAddVibe(name: String) async throws -> [SimpleEventUIO]
    
    /// 이벤트 이름으로 검색하는 함수
    ///
    /// - Parameters:
    ///   - name: 이벤트 이름
    ///
    /// 이벤트 이름으로 검색하는 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 간단한 이벤트 정보가 담긴 UIO의 배열
    ///
    /// - Note: 리턴 값에 검색결과 나온 이벤트의 총 개수인 count 값은 보류라고 써있어서 일단 넣지 않았습니다.
    ///
    /// - Author: 라움
    func searchEventByName(name: String) async throws -> [SimpleEventUIO]
}
