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
/// - Author: Doran, 라움
enum ReplyHTTPRequestRouter {
    case fetchReplies(token: String?, vibeID: Int)
    case addReply(token: String, vibeID: Int, text: String)
    case modifyReply(token: String, replyID: String, vibeID: String, updatedText: String)
    case deleteReply(token: String, replyID: String)
    case likeReply(token: String, replyID: String)
    case cancelLikeReply(token: String, replyID: String)
    case getReplyLikeCount(replyID: String)
    case checkIfUserLikedReply(token: String, vibeID: Int)
}

/// HTTPRequestable을 상속받아서 실제로 Request를 할 때 필요한 data, header, method, url을 만듭니다.
///
/// - Note: accessToken을 키체인에서 가져오는 함수를 여기다 쓰면 문제가 될까요?
///
/// - Author: Doran, 라움
extension ReplyHTTPRequestRouter: HTTPRequestable {
    var method: HTTPMethod {
        switch self {
        case .fetchReplies, .getReplyLikeCount, .checkIfUserLikedReply:
            return .get
        case .addReply, .likeReply:
            return .post
        case .modifyReply:
            return .patch
        case .deleteReply, .cancelLikeReply:
            return .delete
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .fetchReplies(let token, _):
            return token == nil ? nil : [
                "Authorization": "Bearer \(token!)"
            ]
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
            return [
                "Authorization": "Bearer \(token)",
                "content-type": "application/json"
            ]
        case .likeReply(let token, _):
            return [
                "Authorization": "Bearer \(token)",
                "content-type": "application/json"
            ]
        case .cancelLikeReply(let token, _):
            return [
                "Authorization": "Bearer \(token)",
                "content-type": "application/json"
            ]
        case .getReplyLikeCount(_):
            return nil
        case .checkIfUserLikedReply(let token, _):
            return [
                "Authorization": "Bearer \(token)",
                "content-type": "application/json"
            ]
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchReplies, .likeReply, .cancelLikeReply, .getReplyLikeCount, .checkIfUserLikedReply, .deleteReply:
            return nil
        case .addReply(_, let vibeID, let text):
            let json: [String: Any] = [
                "vibeId": vibeID,
                "content": text
            ]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        case .modifyReply(_, let replyID, let vibeID, let updatedText):
            let json: [String: Any] = [
                "id": replyID,
                "vibeId": vibeID,
                "content": updatedText
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
        case .fetchReplies(let token, let vibeID):
            return token == nil ?
            ["open-api", "vibe", "\(vibeID)", "reply"]
            : ["api", "vibe", "\(vibeID)", "reply"]
        case .addReply:
            path.append("register")
        case .modifyReply(_, let replyID, _, _):
            fallthrough
        case .deleteReply(_, let replyID):
            return ["api", "reply", "\(replyID)"]
        case .likeReply(_, let replyID):
            return ["api", "reply", "like", "\(replyID)"]
        case .cancelLikeReply(_, let replyID):
            return ["api", "reply", "like", "\(replyID)"]
        case .getReplyLikeCount(let replyID):
            return ["open-api", "reply", "like", "\(replyID)", "count"]
        case .checkIfUserLikedReply(_, let replyID):
            return ["api", "reply", "liked", "\(replyID)"]
        }
        
        return path
    }
    
    var queryItems: [URLQueryItem]? { nil }
}
