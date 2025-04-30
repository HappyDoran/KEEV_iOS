//
//  URLRequestConvertible.swift
//  KEEVCore
//
//  Created by junsungkim on 4/28/25.
//

public typealias URLComposable = BaseURL & URLEndpoint

public protocol URLRequestConvertible: URLComposable {
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: URLRequestBody? { get }
}
