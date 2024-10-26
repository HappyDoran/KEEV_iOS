//
//  Cachable.swift
//  KEEV
//
//  Created by 김준성 on 10/25/24.
//

import Foundation

/// 캐싱을 해주는 저장소를 만들기 위한 프로토콜
///
/// 캐싱을 하기 위한  객체를 만들 때, 채택하는 프로토콜 입니다.
///
/// 저장, 삭제, 불러오기 등을 위한 key의 타입은 `String`이며,
///
/// 저장할 value의 타입은 `Data`입니다.
///
/// - Author: newJunsung
protocol CacheManagerProtocol: AnyObject {
    /// 키와 데이터를 캐시 매니저에 저장할 때 쓰는 함수.
    func storeInCache(_ value: Data, for key: String) async throws
    /// 키를 바탕으로 데이터를 불러올 때 쓰는 함수.
    func loadFromCache(for key: String) async throws -> Data
    /// 키와 데이터를 삭제하기 위해 쓰는 함수.
    func removeFromCache(for key: String) async throws
}
