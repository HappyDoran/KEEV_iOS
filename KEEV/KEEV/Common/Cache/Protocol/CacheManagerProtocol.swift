//
//  Cachable.swift
//  KEEV
//
//  Created by 김준성 on 10/25/24.
//

import Foundation

protocol CacheManagerProtocol: AnyObject {
    func storeInCache(_ value: Data, for key: String) async throws
    func loadFromCache(for key: String) async throws -> Data
    func removeFromCache(for key: String) async throws
}
