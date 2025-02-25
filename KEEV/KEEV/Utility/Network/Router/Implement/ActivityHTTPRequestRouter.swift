//
//  ActivityHTTPRequestRouter.swift
//  KEEV
//
//  Created by Yune Cho on 11/27/24.
//

import Foundation

/// 사용자 액티비티에 대한 Router들을 나열한 열거형
///
/// - Author: 라움
enum ActivityHTTPRequestRouter {
    case userInfo(userID: Int)
    case userVibeList(userID: Int)
    case userLikedEvents(userID: Int, page: Int, size: Int, sort: [SortParameter])
    
    private var id: Int {
        switch self {
        case .userInfo(let userID):
            userID
        case .userVibeList(let userID):
            userID
        case .userLikedEvents(let userID, _, _, _):
            userID
        }
    }
}

/// HTTPRequestable을 상속받아서 실제로 Request를 할 때 필요한 data, header, method, url을 만듭니다.
///
/// - Author: 라움
extension ActivityHTTPRequestRouter: HTTPRequestable {
    var baseURL: any URLBaseComposable {
        AppEnvironment.keevBaseURL
    }
    
    var body: Data? {
        switch self {
        case .userInfo, .userVibeList, .userLikedEvents: nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .userInfo, .userVibeList, .userLikedEvents:
            return .get
        }
    }
    
    var headers: [String : String]? { nil }
    
    var path: [String]? {
        var path = ["open-api", "user", "\(id)"]
        
        switch self {
        case .userInfo: break
        case .userVibeList: path.append("vibe")
        case .userLikedEvents: path += ["event", "liked"]
        }
        
        return path
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .userInfo, .userVibeList:
            return nil
        case .userLikedEvents(_, let page, let size, let sort):
            var queryItems = [
                URLQueryItem(name: "size", value: "\(size)"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
            
            for parameter in sort {
                let sortItem = URLQueryItem(name: "sort", value: "\(parameter.key),\(parameter.value)")
                queryItems.append(sortItem)
            }
            
            return queryItems
        }
    }
}
