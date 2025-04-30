//
//  URLRequestConvertible.swift
//  KEEVCore
//
//  Created by junsungkim on 4/28/25.
//

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
