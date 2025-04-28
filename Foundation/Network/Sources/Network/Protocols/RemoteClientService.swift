//
//  RemoteClientService.swift
//  Network
//
//  Created by junsungkim on 4/28/25.
//

import Foundation

public typealias APIResponse = (data: Data, statueCode: Int)

public protocol RemoteClientService {
    func request<T: Decodable>(from converter: some URLRequestConvertible, for type: T.Type, decoder: JSONDecoder) async throws -> T
    func request(from converter: some URLRequestConvertible) async throws -> APIResponse
}
