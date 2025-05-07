//
//  RemoteClientService.swift
//  Network
//
//  Created by junsungkim on 4/28/25.
//

import Foundation

/// (data: Data, statusCode: Int)로 구성된 튜플
public typealias APIResponse = (data: Data, statueCode: Int)

/// 서버와 통신하기 위한 네트워크 객체를 만들기 위한 객체
public protocol RemoteClientService: AnyObject {
    func request<T: Decodable>(by converter: some URLRequestConvertible, for type: T.Type, decoder: JSONDecoder) async throws -> T
    func request(by converter: some URLRequestConvertible) async throws -> APIResponse
    func request(from request: URLRequest) async throws -> APIResponse
    func request<T: Decodable>(from request: URLRequest, for type: T.Type, decoder: JSONDecoder) async throws -> T
}
