//
//  ReplyRouter.swift
//  KEEV
//
//  Created by Doran on 11/27/24.
//

import SwiftUI

/// 댓글 읽기, 쓰기, 수정, 삭제에 대한 Router들을 나열한 열거형
///
///  accessToken을 header에 실어서 request 합니다.
///
/// - Author: Doran
enum ReplyHTTPRequestRouter {
    case fetchReplies(token: String, vibeID: Int)
    case addReply(token: String, vibeID: Int, text: String)
    case modifyReply(token: String, replyID: String, vibeID: String, updatedReply: String)
    case deleteReply(token: String, replyID: String)
}

/// HTTPRequestable을 상속받아서 실제로 Request를 할 때 필요한 data, header, method, url을 만듭니다.
///
/// - Note: accessToken을 키체인에서 가져오는 함수를 여기다 쓰면 문제가 될까요?
///
/// - Author: Doran
extension ReplyHTTPRequestRouter: HTTPRequestable {
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
        case .modifyReply(let token, _, _, _):
            return [
                "Authorization": "Bearer \(token)",
                "content-type": "application/json"
            ]
        case .deleteReply(let token, _):
            return ["Authorization": "Bearer \(token)"]
        }
    }
    
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
        case .modifyReply(_, let replyID, let vibeID, let updatedReply):
            let json: [String: Any] = [
                "Id": replyID,
                "vibeId": vibeID,
                "content": updatedReply
            ]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        case .deleteReply(_, let replyID):
            
            let json: [String: Any] = [
                "Id": replyID,
            ]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        }
    }
    
    var baseURL: any URLBaseComposable {
        AppEnvironment.keevBaseURL
    }
    
    var path: [String]? {
        var path = ["comment"]
        
        switch self {
        case .fetchReplies(_, let vibeID):
            path.append(contentsOf: ["get", "\(vibeID)"])
        case .addReply:
            path.append("register")
        case .modifyReply:
            path.append("edit")
        case .deleteReply:
            path.append("delete")
        }
        
        return path
    }
    
    var queryItems: [URLQueryItem]? { nil }
    
}
