//
//  KeyValueStorage.swift
//  KeyValueStorage
//
//  Created by junsungkim on 5/1/25.
//

import Foundation

/// 비동기 키-값 저장소에 대한 추상화 프로토콜입니다.
///
/// 이 프로토콜은 UserDefaults, Keychain 등 다양한 로컬 저장소 구현체에 대해
/// 일관된 저장/조회/삭제 기능을 제공하기 위한 용도로 사용됩니다.
///
/// `Codable`과 `Sendable`을 만족하는 타입만 저장할 수 있습니다.
///
/// 기본 제공되는 `save(_:forKey:)`, `load(_:)`는 기본 인코더/디코더를 사용하는 간편 버전입니다.
public protocol KeyValueStorage: Sendable {

    /// 지정된 키에 해당하는 값을 로드합니다.
    ///
    /// - Parameters:
    ///   - key: 값을 조회할 키
    ///   - decoder: 커스텀 JSONDecoder (기본값은 확장에서 제공)
    /// - Returns: 디코딩된 값 또는 값이 존재하지 않을 경우 nil
    func load<T: Codable & Sendable>(_ key: String, decoder: JSONDecoder) async throws -> T?

    /// 지정된 키에 값을 저장합니다.
    ///
    /// - Parameters:
    ///   - value: 저장할 값
    ///   - key: 값을 저장할 키
    ///   - encoder: 커스텀 JSONEncoder (기본값은 확장에서 제공)
    func save<T: Codable & Sendable>(_ value: T, forKey key: String, encoder: JSONEncoder) async throws

    /// 지정된 키의 값을 삭제합니다.
    ///
    /// - Parameter key: 삭제할 키
    func remove(_ key: String) async
}

public extension KeyValueStorage {
    /// 기본 JSONEncoder를 사용하여 값을 저장합니다.
    func save<T: Codable & Sendable>(_ value: T, forKey key: String) async throws {
        try await save(value, forKey: key, encoder: JSONEncoder())
    }

    /// 기본 JSONDecoder를 사용하여 값을 로드합니다.
    func load<T: Codable & Sendable>(_ key: String) async throws -> T? {
        try await load(key, decoder: JSONDecoder())
    }
}
