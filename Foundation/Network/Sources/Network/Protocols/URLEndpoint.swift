//
//  URLEndpoint.swift
//  KEEVCore
//
//  Created by junsungkim on 4/28/25.
//

/// 엔드포인트(URN)의 요소를 담은 프로토콜
///
/// 패스(path)와 쿼리 아이템으로 구성됩니다.
/// 두 프로퍼티 모두 없어도 될 경우, nil로 지정해주면 됩니다.
public protocol URLEndpoint {
    var path: [String]? { get }
    var queryItems: [String: String]? { get }
}
