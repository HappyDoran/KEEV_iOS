//
//  TokenRouter.swift
//  KEEVCore
//
//  Created by junsungkim on 5/16/25.
//

import Foundation

import Network

struct TokenRouter: URLRequestConvertible {
    let method: Network.HTTPMethod
    let headers: [String : String]
    let body: Network.URLRequestBody?
    let scheme: String
    let host: String
    let port: Int?
    let path: [String]?
    let queryItems: [String : String]?
    
    init(refreshToken: String) {
        self.method = .get
        self.headers = ["Authorization": "Bearer \(refreshToken)"]
        self.body = nil
        self.scheme = "https"
        self.host = "id.apple.com"
        self.port = nil
        self.path = ["api", "auth", "token"]
        self.queryItems = nil
    }
}
