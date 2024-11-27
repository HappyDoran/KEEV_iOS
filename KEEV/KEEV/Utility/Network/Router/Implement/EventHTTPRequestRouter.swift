//
//  EventHTTPRequestRouter.swift
//  KEEV
//
//  Created by Doran on 11/27/24.
//

import SwiftUI

typealias SortParameter = (key: String, value: String)

enum EventHTTPRequestRouter {
    case fetchEvents(page: Int, size: Int, sort: [SortParameter])
    case fetchDetailEvent(eventID: String)
}

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

