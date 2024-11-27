//
//  ReplyService.swift
//  KEEV
//
//  Created by Doran on 11/27/24.
//

import Foundation

class ReplyService: ReplyServiceProtocol {
    private let networkUtility = NetworkUtility()
    
    func fetchReplies(for vibeID: Int) async throws -> [ReplyUIO] {
        let accessToken = try getAccessToken()
        let router = ReplyHTTPRequestRouter.fetchReplies(token: accessToken, vibeID: vibeID)
        
        let (_, data) = try await networkUtility.requestWithStatusCode(router: router)
        let replyDTOs = try JSONDecoder().decode([ReplyDTO].self, from: data)
        let replies = replyDTOs.map { ReplyUIO(ReplyDTO: $0) }
        
        return replies
    }
    
    func addReply(to vibeID: Int, text: String) async throws -> ReplyUIO {
        let accessToken = try getAccessToken()
        let router = ReplyHTTPRequestRouter.addReply(token: accessToken, vibeID: vibeID, text: text)
        
        let (statusCode, data) = try await networkUtility.requestWithStatusCode(router: router)
        
        let replyDTO = try JSONDecoder().decode(ReplyDTO.self, from: data)
        let reply = ReplyUIO(ReplyDTO: replyDTO)
        
        return reply
    }
    
    func modifyReply(_ reply: ReplyUIO, updatedReply: String) async throws -> ReplyUIO {
        let accessToken = try getAccessToken()
        let router = ReplyHTTPRequestRouter.modifyReply(
            token: accessToken,
            replyID: "\(reply.id)",
            vibeID: "\(reply.vibeID)",
            updatedReply: updatedReply
        )
        
        let (statusCode, data) = try await networkUtility.requestWithStatusCode(router: router)
        
        print(statusCode, data)
        
        let replyDTO = try JSONDecoder().decode(ReplyDTO.self, from: data)
        let reply = ReplyUIO(ReplyDTO: replyDTO)
        
        return reply
    }
    
//    func deleteReply(_ replyID: Int) async throws {
//        <#code#>
//    }
    
    
}

extension ReplyService {
    private func getAccessToken() throws -> String {
//        guard let accessTokenData = TokenKeyChainUtility().read(tokenTag: "accessToken"),
//              let token = String(data: accessTokenData, encoding: .utf8) else {
//            print("accessToken not found")
//            throw TokenKeyChainError.NotFound
//        }
        
        return "accessToken"
    }
}
