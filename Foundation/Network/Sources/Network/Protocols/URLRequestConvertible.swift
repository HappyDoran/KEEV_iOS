//
//  URLRequestConvertible.swift
//  KEEVCore
//
//  Created by junsungkim on 4/28/25.
//

import Foundation

public typealias URLComposable = BaseURL & URLEndpoint

/// URLRequest를 만들기 위한 요소를 담은 프로토콜
///
/// 이 프로토콜은 BaseURL 프로토콜과 URLEndpoint 프로토콜을 상속받고 있습니다.]
/// 따라서 두 프로토콜의 프로퍼티를 모두 담아야 합니다.
public protocol URLRequestConvertible: URLComposable {
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: URLRequestBody? { get }
}


public extension URLRequestConvertible {
    /// 프로토콜의 프로퍼티를 활용하여, URLRequest를 만드는 함수
    ///
    /// 스킴 또는 호스트가 조건에 맞지 않으면 URLError(.badURL)을 던집니다.
    /// body에서 데이터로 변환하는 과정에서 에러가 발생할 수도 있습니다.
    func buildRequest() throws -> URLRequest {
        var components = URLComponents()
        
        guard let url = components.build(from: self) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        request.allHTTPHeaderFields = self.headers
        request.httpBody = try self.body?.toData()
        return request
    }
}
