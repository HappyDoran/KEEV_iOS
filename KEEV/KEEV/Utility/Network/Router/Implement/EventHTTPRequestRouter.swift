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
    case fetchFilteredEvents(size: Int, page: Int, eventTypeID: Int?, genreID: Int?, startDate: String?, endDate: String?, mode: String, desc: Bool)
    case fetchDetailEvent(eventID: String)
}

/// HTTPRequestable을 상속받아서 실제로 Request를 할 때 필요한 data, header, method, url을 만듭니다.
///
/// - Author: Doran
extension EventHTTPRequestRouter: HTTPRequestable {
    var method: HTTPMethod {
        switch self {
        case .fetchEvents, .fetchFilteredEvents, .fetchDetailEvent:
            return .get
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .fetchEvents, .fetchFilteredEvents, .fetchDetailEvent:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchEvents, .fetchFilteredEvents, .fetchDetailEvent:
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
        case .fetchFilteredEvents:
            path.append(contentsOf: ["get", "filtered"])
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
        case .fetchFilteredEvents(size: let size, page: let page, eventTypeID: let eventTypeID, genreID: let genreID, startDate: let startDate, endDate: let endDate, mode: let mode, desc: let desc):
            var queryItems = [
                URLQueryItem(name: "size", value: "\(size)"),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "mode", value: mode),
                URLQueryItem(name: "desc", value: "\(desc)")
            ]
            
            if let eventTypeID = eventTypeID {
                queryItems.append(URLQueryItem(name: "eventTypeID", value: "\(eventTypeID)"))
            }
            
            if let genreID = genreID {
                queryItems.append(URLQueryItem(name: "eventGenreID", value: "\(genreID)"))
            }
            
            if let startDate = startDate {
                queryItems.append(URLQueryItem(name: "startDate", value: startDate))
            }
            
            if let endDate = endDate {
                queryItems.append(URLQueryItem(name: "endDate", value: endDate))
            }
            
            return queryItems
        case .fetchDetailEvent(eventID: let eventID):
            return nil
        }
    }
}

