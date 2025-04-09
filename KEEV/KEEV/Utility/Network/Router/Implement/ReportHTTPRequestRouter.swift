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
    case replyReport(token: String, vibeID: Int, replyID: Int, reason: String)
    case vibeReport(token: String, eventID: Int, vibeID: Int, reason: String)
    case userReport(token: String, userID: Int, reason: String)
    case eventReport(token: String, eventID: Int, reason: String)
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
        case .replyReport(_, let vibeID, let replyID, let reason):
            let json: [String: Any] = [
                "vibeId": vibeID,
                "commentId": replyID,
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
        case .replyReport(let token, _, _, _), .vibeReport(let token, _, _, _), .userReport(let token, _, _), .eventReport(let token, _, _):
            return [
                "Authorization": "Bearer \(token)",
                "content-type": "application/json"
            ]
        }
    }
    
    var path: [String]? {
        var path = ["report"]
        
        switch self {
        case .replyReport:
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
