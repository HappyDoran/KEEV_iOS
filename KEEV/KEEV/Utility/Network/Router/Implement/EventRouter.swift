//
//  EventRouter.swift
//  KEEV
//
//  Created by Doran on 10/18/24.
//

import Foundation

/// Event에 대한 API, Server와의 통신을 정의하는 열거형
///
/// 공연 관련 API 요청 및 서버와의 통신을 구성하기 위한 케이스를 포함합니다.
///
/// - Author: Doran
enum EventRouter {
    case getEvents(eddate: String, cpage: String, rows:String)
}

/// HTTPRequestable 프로토콜을 준수하기 위한 확장
///
///  API요청, 서버와의 통신을 구성하는데 필요한 속성과 메소드를 제공
///
/// - Note: 각 요청마다 인스턴스가 생성됩니다.
/// - Author: Doran
extension EventRouter: HTTPRequestable {
    /// http scheme 반환
    var scheme: String { "http" }
    
    /// HTTP 메소드 반환
    var method: HTTPMethod {
        switch self {
        case .getEvents:
                .get
        }
    }
    
    /// 호스트 반환
    var host: String {
        AppEnvironment.kopisBaseURL.host ?? "kopis.or.kr"
    }
    
    /// 포트를 반환, API 통신을 할때는 포트가 따로 필요 없으므로 nil
    var port: Int? { nil }
    
    /// 필수적으로 들어가는 경로 반환
    var path: [String]? {
        let path = ["openApi","restful","pblprfr"]
    
        return path
    }
    
    /// API 통신에 필요한 쿼리 반환
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getEvents(let eddate, let cpage, let rows):
            return [
                URLQueryItem(name: "service", value: AppEnvironment.kopisApiKey),
                URLQueryItem(name: "stdate", value: "20240304"),
                URLQueryItem(name: "eddate", value: eddate),
                URLQueryItem(name: "cpage", value: cpage),
                URLQueryItem(name: "rows", value: rows),
                URLQueryItem(name: "shcate", value: "CCCD")
            ]
        }
    }
}
