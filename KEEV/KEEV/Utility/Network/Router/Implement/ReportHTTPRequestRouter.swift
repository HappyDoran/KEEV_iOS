//
//  ReportHTTPRequestRouter.swift
//  KEEV
//
//  Created by Yune Cho on 11/27/24.
//

import SwiftUI

enum ReportHTTPRequestRouter {
    case commentReport(token: String, vibeId: Int, commentId: String, reason: String)
    case vibeReport(token: String, eventId: String, vibeId: Int, reason: String)
    case userReport(token: String, userId: Int, reason: String)
    case eventReport(token: String, eventId: String, reason: String)
}

extension ReportHTTPRequestRouter: HTTPRequestable {
    var scheme: String { "https" }
    var host: String { AppEnvironment.keevBaseURL }
    var port: Int? { nil }
    
    var body: Data? {
        switch self {
        case .commentReport(_, let vibeId, let commentId, let reason):
            let json: [String: Any] = [
                "vibeId": vibeId,
                "commentId": commentId,
                "reason": reason
            ]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        case .vibeReport(_, let eventId, let vibeId, let reason):
            let json: [String: Any] = [
                "eventId": eventId,
                "vibeId": vibeId,
                "reason": reason
            ]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        case .userReport(_, let userId, let reason):
            let json: [String: Any] = [
                "userId": userId,
                "reason": reason
            ]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        case .eventReport(_, let eventId, let reason):
            let json: [String: Any] = [
                "eventId": eventId,
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
            path.append("comment")
        case .eventReport:
            path.append("event")
        }
        
        return path
    }
}
