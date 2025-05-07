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
struct Todo: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}

extension Todo: Equatable {
    static let result0 = Todo(userId: 1, id: 1, title: "delectus aut autem", completed: false)
}

struct MockRouter: URLRequestConvertible {
    let scheme: String = "https"
    let host: String = "jsonplaceholder.typicode.com"
    let port: Int? = nil
    let path: [String]?
    let queryItems: [String : String]? = nil
    let method: Network.HTTPMethod = .get
    let headers: [String : String] = [:]
    let body: Network.URLRequestBody? = nil
    
    init(path: [String]? = nil) {
        self.path = path
    }
}

extension MockRouter {
    static let request: URLRequest = {
        var components = URLComponents()
        let url = components.build(from: MockRouter(path: ["todos/1"]))!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }()
}

// MARK: 테스트 케이스
@Test func 라우터를_통해_리퀘스트했을_때_디코딩이_제대로_되어_Todo를_반환된다() async throws {
    let service = DefaultRemoteClientService()
    let router = MockRouter(path: ["todos/1"])
    let test0 = try await service.request(by: router, for: Todo.self)
    #expect(test0 == Todo.result0)
}

@Test func 라우터를_통해_리퀘스트했을_때_디코딩을_실패하여_에러를_반환한다() async throws {
    let service = DefaultRemoteClientService()
    let router = MockRouter(path: ["users/1/posts"])
    await #expect(throws: DecodingError.self) {
        let _ = try await service.request(by: router, for: Todo.self)
    }
}

@Test func 라우터를_통해_리퀘스트했을_때_데이터가_정상적으로_반환된다() async throws {
    let service = DefaultRemoteClientService()
    let decoder = JSONDecoder()
    let router = MockRouter(path: ["todos/1"])
    let (data, _) = try await service.request(by: router)
    let test0 = try decoder.decode(Todo.self, from: data)
    #expect(test0 == Todo.result0)
}


@Test func URLRequest를_통해_리퀘스트했을_때_데이터가_정상적으로_디코딩된다() async throws {
    let service = DefaultRemoteClientService()
    let todo = try await service.request(from: MockRouter.request, for: Todo.self)
    #expect(todo == Todo.result0)
}

@Test func URLRequest를_통해_리퀘스트했을_때_데이터가_정상적으로_반환된다() async throws {
    let service = DefaultRemoteClientService()
    let (data, _) = try await service.request(from: MockRouter.request)
    let decoder = JSONDecoder()
    let test0 = try decoder.decode(Todo.self, from: data)
    #expect(test0 == Todo.result0)
}
