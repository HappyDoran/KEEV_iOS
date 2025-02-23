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
    case getVibeCount(token: String, eventID: String)
    case getVibes(token: String, page: Int, size: Int, sort: [SortParameter])
    case getVibesFromEventID(token: String, id: String, page: Int, size: Int, sort: [SortParameter])
    /// 각각의 요소를 인자로 받던 것과 달리 바이브 업로드는 MultipartFormBuilder로 처리된 데이터를 인자로 받습니다.
    case uploadVibe(token: String, eventID: String, data: Data)
    case deleteVibe(token: String, vibeID: Int)
    /// 각각의 요소를 인자로 받던 것과 달리 바이브 수정은 MultipartFormBuilder로 처리된 데이터를 인자로 받습니다.
    case modifyVibe(token: String, vibeID: Int, data: Data)
    case checkIfUserUploadedVibe(token: String, eventID: String)
    case getVibeWithVibeID(token: String, vibeID: Int)
    case likeVibe(token: String, vibeID: Int)
    case cancelLikeVibe(token: String, vibeID: Int)
    case getVibeLikeCount(vibeID: Int)
    case checkIfUserLikedVibe(token: String, vibeID: Int)
}

/// HTTPRequestable을 상속받아서 실제로 Request를 할 때 필요한 data, header, method, url을 만듭니다.
///
/// - Author: 라움
extension VibeHTTPRequestRouter: HTTPRequestable {
    var method: HTTPMethod {
        switch self {
        case .getVibeCount, .getVibes, .checkIfUserUploadedVibe, .getVibeWithVibeID, .getVibesFromEventID, .getVibeLikeCount, .checkIfUserLikedVibe:
                .get
        case .uploadVibe, .likeVibe:
                .post
        case .deleteVibe, .cancelLikeVibe:
                .delete
        case .modifyVibe:
                .patch
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getVibes(let token, _, _, _), .getVibeWithVibeID(let token, _), .getVibesFromEventID(let token, _, _, _, _), .getVibeCount(let token, _), .uploadVibe(let token, _, _), .deleteVibe(let token, _), .modifyVibe(let token, _, _), .checkIfUserUploadedVibe(let token, _), .likeVibe(let token, _), .cancelLikeVibe(let token, _), .checkIfUserLikedVibe(let token, _):
            return [
                "Authorization": "Bearer \(token)",
                "content-type": "application/json"
            ]
        case .getVibeLikeCount:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .getVibeCount, .getVibes, .getVibeWithVibeID, .checkIfUserUploadedVibe, .getVibesFromEventID, .likeVibe, .cancelLikeVibe, .getVibeLikeCount, .checkIfUserLikedVibe:
            return nil
        case .uploadVibe(_, _, let data):
            return data
        case .deleteVibe(_, let vibeID):
            let json: [String: Any] = [
                "id": vibeID
            ]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        case .modifyVibe(_, _, let data):
            return data
        }
    }
    
    var baseURL: any URLBaseComposable {
        AppEnvironment.keevBaseURL
    }
    
    var path: [String]? {
        var path = ["vibe"]
        
        switch self {
        case .getVibeCount(_, let eventID):
            path.append(contentsOf: ["count", "\(eventID)"])
        case .getVibes:
            path.append(contentsOf: ["get", "sortBy"])
        case .getVibesFromEventID(_, let id, _, _, _):
            path.append(contentsOf: ["get", id, "sortBy"])
        case .uploadVibe(_, let eventID, _):
            path.append(contentsOf: ["register", "\(eventID)"])
        case .deleteVibe:
            path.append(contentsOf: ["delete"])
        case .modifyVibe(_, let vibeID, _):
            path.append(contentsOf: ["update", "\(vibeID)"])
        case .checkIfUserUploadedVibe(_, let eventID):
            path.append(contentsOf: ["find", "\(eventID)"])
        case .getVibeWithVibeID(_, let vibeID):
            path.append(contentsOf: ["get", "\(vibeID)"])
        case .likeVibe(_, let vibeID):
            path.append(contentsOf: ["like", "\(vibeID)"])
        case .cancelLikeVibe(_, let vibeID):
            path.append(contentsOf: ["like", "\(vibeID)"])
        case .getVibeLikeCount(let vibeID):
            path.append(contentsOf: ["like", "\(vibeID)", "count"])
        case .checkIfUserLikedVibe(_, let vibeID):
            path.append(contentsOf: ["liked", "\(vibeID)"])
        }
        
        return path
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getVibes(_, let page, let size, let sort), .getVibesFromEventID(_, _, let page, let size, let sort):
            var queryItems = [
                URLQueryItem(name: "size", value: "\(size)"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
            
            for parameter in sort {
                let sortItem = URLQueryItem(name: "sort", value: "\(parameter.key),\(parameter.value)")
                queryItems.append(sortItem)
            }
            
            return queryItems
        case .getVibeCount, .uploadVibe, .deleteVibe, .modifyVibe, .checkIfUserUploadedVibe, .getVibeWithVibeID, .likeVibe, .cancelLikeVibe, .getVibeLikeCount, .checkIfUserLikedVibe:
            return nil
        }
    }
}
