//
//  SearchHTTPRequestRouter.swift
//  KEEV
//
//  Created by Yune Cho on 12/1/24.
//

import Foundation

/// 검색과 관련된 기능에 대한 Router들을 나열한 열거형
///
/// - Author: 라움
enum SearchHTTPRequestRouter {
    case searchEventByNameWhenAddVibe(name: String, size: Int, page: Int)
    case searchEventByName(name: String, size: Int, page: Int)
}

/// HTTPRequestable을 상속받아서 실제로 Request를 할 때 필요한 data, header, method, url을 만듭니다.
///
/// - Author: 라움
extension SearchHTTPRequestRouter: HTTPRequestable {
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var body: Data? {
        nil
    }
    
    var baseURL: any URLBaseComposable {
        AppEnvironment.keevBaseURL
    }
    
    var path: [String]? {
        switch self {
        case .searchEventByNameWhenAddVibe:
            return ["open-api", "event", "search", "started"]
        case .searchEventByName:
            return ["open-api", "event", "search"]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .searchEventByNameWhenAddVibe(name: let name, size: let size, page: let page), .searchEventByName(name: let name, size: let size, page: let page):
            let queryItems = [
                URLQueryItem(name: "name", value: name),
                URLQueryItem(name: "size", value: "\(size)"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
            
            return queryItems
        }
    }
}
