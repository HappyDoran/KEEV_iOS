//
//  VibeHTTPRequestRouter.swift
//  KEEV
//
//  Created by Yune Cho on 11/28/24.
//

import Foundation
import SwiftUI

/// 바이브와 관련된 기능에 대한 Router들을 나열한 열거형
///
/// 일부 case는 accessToken을 header에 실어서 request 합니다.
///
/// - Author: 라움
enum VibeHTTPRequestRouter {
    case getVibes(page: Int, size: Int, sort: [SortParameter])
    /// 각각의 요소를 인자로 받던 것과 달리 바이브 업로드는 MultipartFormBuilder로 처리된 데이터를 인자로 받습니다.
    case uploadVibe(token: String, eventID: String, data: Data)
    case deleteVibe(token: String, eventID: String, vibeID: Int)
    /// 각각의 요소를 인자로 받던 것과 달리 바이브 수정은 MultipartFormBuilder로 처리된 데이터를 인자로 받습니다.
    case modifyVibe(token: String, vibeID: Int, data: Data)
    case checkIfUserUploadedVibe(token: String, eventID: String, userID: Int)
    case getVibeWithVibeID(vibeID: Int)
}

/// HTTPRequestable을 상속받아서 실제로 Request를 할 때 필요한 data, header, method, url을 만듭니다.
///
/// - Author: 라움
extension VibeHTTPRequestRouter: HTTPRequestable {
    var method: HTTPMethod {
        switch self {
        case .getVibes, .checkIfUserUploadedVibe, .getVibeWithVibeID:
                .get
        case .uploadVibe:
                .post
        case .deleteVibe:
                .delete
        case .modifyVibe:
                .patch
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getVibes, .getVibeWithVibeID:
            return nil
        case .uploadVibe(let token, _, _), .deleteVibe(let token, _, _), .modifyVibe(let token, _, _), .checkIfUserUploadedVibe(let token, _, _):
            return [
                "Authorization": "Bearer \(token)",
                "content-type": "application/json"
            ]
        }
    }
    
    var body: Data? {
        switch self {
        case .getVibes, .getVibeWithVibeID:
            return nil
        case .uploadVibe(_, _, let data):
            return data
        case .deleteVibe(_, let eventID, let vibeID):
            let json: [String: Any] = [
                "eventId": eventID,
                "vibeId": vibeID
            ]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        case .modifyVibe(_, _, let data):
            return data
        case .checkIfUserUploadedVibe(_, _, let userID):
            let json: [String: Int] = [
                "userId": userID
            ]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        }
    }
    
    var baseURL: any URLBaseComposable {
        AppEnvironment.keevBaseURL
    }
    
    var path: [String]? {
        var path = ["vibe"]
        
        switch self {
        case .getVibes:
            path.append(contentsOf: ["get", "sortBy"])
        case .uploadVibe(_, let eventID, _):
            path.append(contentsOf: ["register", "\(eventID)"])
        case .deleteVibe:
            path.append(contentsOf: ["delete"])
        case .modifyVibe(_, let vibeID, _):
            path.append(contentsOf: ["update", "\(vibeID)"])
        case .checkIfUserUploadedVibe(_, let eventID, _):
            path.append(contentsOf: ["find", "\(eventID)"])
        case .getVibeWithVibeID(let vibeID):
            // 향후에 endpoint 나오면 수정해야합니다.
            path.append(contentsOf: ["get", "\(vibeID)"])
        }
        
        return path
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getVibes(page: let page, size: let size, sort: let sort):
            var queryItems = [
                URLQueryItem(name: "size", value: "\(size)"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
            
            for parameter in sort {
                let sortItem = URLQueryItem(name: "sort", value: "\(parameter.key),\(parameter.value)")
                queryItems.append(sortItem)
            }
            
            return queryItems
        case .uploadVibe, .deleteVibe, .modifyVibe, .checkIfUserUploadedVibe, .getVibeWithVibeID:
            return nil
        }
    }
}
