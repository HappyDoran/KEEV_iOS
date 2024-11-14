//
//  ServerRouter.swift
//  KEEV
//
//  Created by Yune Cho on 11/14/24.
//

import Foundation

/// Server와의 통신을 정의하는 열거형
///
/// 서버와의 통신을 구성하기 위한 케이스를 포함합니다.
///
/// - Author: 라움
enum ServerRouter {
    case getEventTypes
    case getCountries
    case getGenres
    case getPlaces
}

/// HTTPBaseRequestable 프로토콜을 준수하기 위한 확장
///
/// 서버와의 통신을 구성하는데 필요한 속성과 메소드를 제공
///
/// - Note: 각 요청마다 인스턴스가 생성됩니다.
/// - Author: 라움
extension ServerRouter: HTTPBaseRequestable {
    /// http scheme 반환
    var scheme: String { "http" }
    
    /// HTTP 메소드 반환
    var method: HTTPMethod {
        switch self {
        case .getEventTypes, .getCountries, .getGenres, .getPlaces:
                .get
        }
    }
    
    /// 호스트 반환
    var host: String {
        AppEnvironment.serverIPAddress
    }
    
    /// 포트를 반환
    var port: Int? {
        8080
    }
}
