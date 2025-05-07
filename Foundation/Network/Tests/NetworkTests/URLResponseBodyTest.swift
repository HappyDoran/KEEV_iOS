//
//  File.swift
//  Network
//
//  Created by junsungkim on 4/29/25.
//

import Foundation
import Testing
@testable import Network

// MARK: 목 타입
struct Human: Codable {
    let name: String
    let age: Int
    let isStudent: Bool
}

extension Human: Equatable {
    static let data = """
    {"name":"홍길동","age":17,"isStudent":true}
    """.data(using: .utf8)!
}

func decodeData(_ data: Data) -> Human {
    try! JSONDecoder().decode(Human.self, from: data)
}

// MARK: 테스트
@Test func Data가_정상적으로_Data로_나오는지() async throws {
    let test = try URLRequestBody.data(Human.data).toData()
    #expect(decodeData(test) == decodeData(Human.data))
}

@Test func Encodable이_정상적으로_데이터로_변환이_되는지() async throws {
    let encoder = JSONEncoder()
    let human = Human(name: "홍길동", age: 17, isStudent: true)
    let test = try URLRequestBody.encodable(type: human, encoder: encoder).toData()
    #expect(decodeData(test) == decodeData(Human.data))
}

@Test func JSONSerial이_정상적으로_데이터로_변환이_되는지() async throws {
    let dictionary: [String: Any] = ["name": "홍길동", "age": 17, "isStudent": true]
    let test = try URLRequestBody.serialize(dictionary).toData()
    #expect(decodeData(test) == decodeData(Human.data))
}
