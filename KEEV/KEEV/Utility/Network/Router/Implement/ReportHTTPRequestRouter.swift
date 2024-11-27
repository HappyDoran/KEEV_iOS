//
//  ReportHTTPRequestRouter.swift
//  KEEV
//
//  Created by Yune Cho on 11/27/24.
//

import SwiftUI

/// 신고하기에 대한 Router들을 나열한 열거형
///
/// accessToken을 header에 실어서 request 합니다.
///
/// - Author: 라움
enum ReportHTTPRequestRouter {
    case commentReport(token: String, vibeID: Int, commentID: String, reason: String)
    case vibeReport(token: String, eventID: String, vibeID: Int, reason: String)
    case userReport(token: String, userID: Int, reason: String)
    case eventReport(token: String, eventID: String, reason: String)
}

/// HTTPRequestable을 상속받아서 실제로 Request를 할 때 필요한 data, header, method, url을 만듭니다.
///
/// - Author: 라움
extension ReportHTTPRequestRouter: HTTPRequestable {
    var baseURL: any URLBaseComposable {
        AppEnvironment.keevBaseURL
    }
    
    var body: Data? {
        switch self {
        case .commentReport(_, let vibeID, let commentID, let reason):
            let json: [String: Any] = [
                "vibeId": vibeID,
                "commentId": commentID,
                "reason": reason
            ]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        case .vibeReport(_, let eventID, let vibeID, let reason):
            let json: [String: Any] = [
                "eventId": eventID,
                "vibeId": vibeID,
                "reason": reason
            ]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        case .userReport(_, let userID, let reason):
            let json: [String: Any] = [
                "userId": userID,
                "reason": reason
            ]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        case .eventReport(_, let eventID, let reason):
            let json: [String: Any] = [
                "eventId": eventID,
                "reason": reason
            ]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        }
    }
    
    var method: HTTPMethod { .post }
    
    var headers: [String : String]? {
        switch self {
        case .commentReport(let token, _, _, _), .vibeReport(let token, _, _, _), .userReport(let token, _, _), .eventReport(let token, _, _):
            return [
                "Authorization": "Bearer \(token)",
                "content-type": "application/json"
            ]
        }
    }
    
    var path: [String]? {
        var path = ["report"]
        
        switch self {
        case .commentReport:
            path.append("comment")
        case .vibeReport:
            path.append("vibe")
        case .userReport:
            path.append("user")
        case .eventReport:
            path.append("event")
        }
        
        return path
    }
    
    var queryItems: [URLQueryItem]? { nil }
}
