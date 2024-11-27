//
//  ReplyRouter.swift
//  KEEV
//
//  Created by Doran on 11/27/24.
//

import SwiftUI

enum ReplyRouter {
    case fetchReplies(token: String, vibeID: Int)
    case addReply(token: String, vibeID: Int, text: String)
    case modifyReply(token: String, reply: ReplyDTO, updatedReply: String)
    case deleteReply(token: String, reply: ReplyDTO)
}

extension ReplyRouter: HTTPRequestable {
    var body: Data? {
        switch self {
        case .fetchReplies:
            return nil
        case .addReply(_, let vibeID, let text):
            let json: [String: Any] = [
                "vibeId": vibeID,
                "content": text
            ]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        case .modifyReply(_, let reply, let updatedReply):
            let json: [String: Any] = [
                "Id": reply.id,
                "vibeId": reply.vibeID,
                "content": updatedReply
            ]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        case .deleteReply(_, let reply):
            
            let json: [String: Any] = [
                "Id": reply.id,
                "vibeId": reply.vibeID
            ]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        }
    }
    
    var scheme: String { "https" }
    
    var method: HTTPMethod {
        switch self {
        case .fetchReplies:
            return .get
        case .addReply:
            return .post
        case .modifyReply:
            return .patch
        case .deleteReply:
            return .delete
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .fetchReplies(let token, _):
            return ["Authorization": "Bearer \(token)"]
        case .addReply(let token, _, _):
            return [
                "Authorization": "Bearer \(token)",
                "content-type": "application/json"
            ]
        case .modifyReply(let token, _, _):
            return [
                "Authorization": "Bearer \(token)",
                "content-type": "application/json"
            ]
        case .deleteReply(let token, _):
            return ["Authorization": "Bearer \(token)"]
        }
    }
    
    var baseURL: any URLBaseComposable { AppEnvironment.keevBaseURL }
    
    var path: [String]? {
        var path = ["comment"]
        
        switch self {
        case .fetchReplies(_, let vibeID):
            path.append(contentsOf: ["get", "\(vibeID)"])
        case .addReply(_, _, _):
            path.append("register")
        case .modifyReply(_, _, _):
            path.append("edit")
        case .deleteReply(_, _):
            path.append("delete")
        }
        
        return path
    }
    
    var queryItems: [URLQueryItem]? { nil }
}
