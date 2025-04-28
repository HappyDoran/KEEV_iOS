//
//  URLEndpoint.swift
//  KEEVCore
//
//  Created by junsungkim on 4/28/25.
//

public protocol URLEndpoint {
    var path: [String]? { get }
    var queryItems: [String: String]? { get }
}
