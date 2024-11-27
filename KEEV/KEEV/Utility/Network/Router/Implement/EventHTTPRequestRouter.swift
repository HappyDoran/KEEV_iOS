//
//  EventHTTPRequestRouter.swift
//  KEEV
//
//  Created by Doran on 11/27/24.
//

import SwiftUI

///sort에 넣을 QueryItem를 위한 딕셔너리
typealias SortParameter = (key: String, value: String)

/// 이벤트 불러오기, 상세 이벤트 불러오기에 대한 Router들을 나열한 열거형
///
/// - Author: Doran
enum EventHTTPRequestRouter {
    case fetchEvents(page: Int, size: Int, sort: [SortParameter])
    case fetchDetailEvent(eventID: String)
}

/// HTTPRequestable을 상속받아서 실제로 Request를 할 때 필요한 data, header, method, url을 만듭니다.
///
/// - Author: Doran
extension EventHTTPRequestRouter: HTTPRequestable {
    var method: HTTPMethod {
        switch self {
        case .fetchEvents, .fetchDetailEvent:
            return .get
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .fetchEvents, .fetchDetailEvent:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchEvents, .fetchDetailEvent:
            return nil
        }
    }
    
    var baseURL: any URLBaseComposable {
        AppEnvironment.keevBaseURL
    }
    
    var path: [String]? {
        var path = ["event"]
        
        switch self {
        case .fetchEvents:
            path.append(contentsOf: ["get", "sortBy"])
        case .fetchDetailEvent(let eventID):
            path.append(contentsOf: ["get", "\(eventID)"])
        }
        
        return path
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchEvents(page: let page, size: let size, sort: let sort):
            
            var queryItems = [
                URLQueryItem(name: "size", value: "\(size)"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
            
            for parameter in sort {
                let sortItem = URLQueryItem(name: "sort", value: "\(parameter.key),\(parameter.value)")
                queryItems.append(sortItem)
            }
            
            return queryItems
        case .fetchDetailEvent(eventID: let eventID):
            return nil
        }
    }
}

