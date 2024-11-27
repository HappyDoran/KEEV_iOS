//
//  ReplyService.swift
//  KEEV
//
//  Created by Doran on 11/27/24.
//

import Foundation

class ReplyService: ReplyServiceProtocol {
    private let networkUtility = NetworkUtility()
    
    /// 바이브에 대한 댓글을 가져오는 함수
    ///
    /// - Parameters:
    ///   - vibeID : 바이브 아이디
    ///
    /// 키체인에서 accessToken을 가져옵니다.
    /// ReplyHTTPRequestRouter를 통해 라우터를 만듭니다.
    /// 만든 라우터로 서버에 vibeID를 request 하고 바이브에 대한 댓글을 가져옵니다.
    ///
    /// - Returns: 바이브에 대한 댓글들
    ///
    /// - Author: Doran
    func fetchReplies(for vibeID: Int) async throws -> [ReplyUIO] {
        let accessToken = try getAccessToken()
        let router = ReplyHTTPRequestRouter.fetchReplies(token: accessToken, vibeID: vibeID)
        
        let (_, data) = try await networkUtility.requestWithStatusCode(router: router)
        
        let replyDTOs = try JSONDecoder().decode([ReplyDTO].self, from: data)
        let replies = replyDTOs.map { ReplyUIO(ReplyDTO: $0) }
        
        return replies
    }
    
    /// 바이브에 댓글을 추가하는 함수
    ///
    /// - Parameters:
    ///   - vibeID: 바이브 아이디
    ///   - text: 추가하고자 하는 텍스트
    ///
    /// 키체인에서 accessToken을 가져옵니다.
    /// ReplyHTTPRequestRouter를 통해 라우터를 만듭니다.
    /// 만든 라우터로 서버에 vibeID와 추가하고자하는 Text를 request하고 바이브에 댓글을 작성합니다.
    ///
    /// - Returns: 추가한 댓글
    ///
    /// - Author: Doran
    func addReply(to vibeID: Int, text: String) async throws -> ReplyUIO {
        let accessToken = try getAccessToken()
        let router = ReplyHTTPRequestRouter.addReply(token: accessToken, vibeID: vibeID, text: text)
        
        let (_, data) = try await networkUtility.requestWithStatusCode(router: router)
        
        let replyDTO = try JSONDecoder().decode(ReplyDTO.self, from: data)
        let reply = ReplyUIO(ReplyDTO: replyDTO)
        
        return reply
    }
    
    /// 바이브에 대한 댓글을 수정하는 함수
    ///
    /// - Parameters:
    ///   - reply: 수정할 하는 댓글 객체
    ///   - updatedReply: 반영되는 댓글 텍스트
    ///
    /// 키체인에서 accessToken을 가져옵니다.
    /// ReplyHTTPRequestRouter를 통해 라우터를 만듭니다.
    /// 만든 라우터로 서버에 replyID와 vibeID, 수정하고자 하는 텍스트를 request하고 바이브의 댓글을 수정합니다.
    ///
    /// - Throws: 수정할 댓글을 찾지 못할 경우 에러
    /// - Returns: 수정 완료한 객체
    ///
    /// - Author: Doran
    func modifyReply(_ reply: ReplyUIO, updatedReply: String) async throws -> ReplyUIO {
        let accessToken = try getAccessToken()
        let router = ReplyHTTPRequestRouter.modifyReply(
            token: accessToken,
            replyID: "\(reply.id)",
            vibeID: "\(reply.vibeID)",
            updatedReply: updatedReply
        )
        
        let (_, data) = try await networkUtility.requestWithStatusCode(router: router)
        
        let replyDTO = try JSONDecoder().decode(ReplyDTO.self, from: data)
        let reply = ReplyUIO(ReplyDTO: replyDTO)
        
        return reply
    }
    
    /// 바이브에 대한 댓글을 삭제하는 함수
    ///
    /// - Parameters:
    ///   - replyID: 삭제할 댓글 아이디
    ///   - vibeID: 삭제할 댓글이 존재하는 바이브 아이디
    ///
    /// - Throws: 삭제할 댓글을 찾지 못할 경우 에러
    ///
    /// - Author: Doran
    func deleteReply(_ replyID: Int, vibeID: Int) async throws {
        let accessToken = try getAccessToken()
        let router = ReplyHTTPRequestRouter.deleteReply(token: accessToken, replyID: "\(replyID)", vibeID: "\(vibeID)")
        
        _ = try await networkUtility.request(router: router)
    }
}

extension ReplyService {
    private func getAccessToken() throws -> String {
        guard let accessTokenData = TokenKeyChainUtility().read(tokenTag: "accessToken"),
              let token = String(data: accessTokenData, encoding: .utf8) else {
            print("accessToken not found")
            throw TokenKeyChainError.NotFound
        }
        
        return token
    }
}
