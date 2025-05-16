//
//  APIClient.swift
//  Network
//
//  Created by junsungkim on 4/28/25.
//

import Foundation

/// 서버 응답 데이터를 담는 튜플 (data, statusCode)
public typealias APIResponse = (data: Data, statueCode: Int)

/// 서버와 통신하는 네트워크 클라이언트를 정의하는 프로토콜
public protocol APIClient: AnyObject, Sendable {
    func request<T: Decodable>(by converter: some URLRequestConvertible, for type: T.Type, decoder: JSONDecoder) async throws -> T
    func request(by converter: some URLRequestConvertible) async throws -> APIResponse
    func request(from request: URLRequest) async throws -> APIResponse
    func request<T: Decodable>(from request: URLRequest, for type: T.Type, decoder: JSONDecoder) async throws -> T
}
