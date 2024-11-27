//
//  ReplyService.swift
//  KEEV
//
//  Created by Doran on 11/26/24.
//

import Foundation

/// 댓글에 대한 에러 열거
///
/// - Author: Doran
enum ReplyServiceError: Error {
    case replyNotFound
}

class MockReplyService: ReplyServiceProtocol {
    
    private var replies: [ReplyUIO] = [
        .dummy0,
        .dummy1,
        .dummy2,
        .dummy3
    ]
    
    func fetchReplies(for vibeID: Int) async throws -> [ReplyUIO] {
        
        // 서버에서 vibeID를 가지고 replies를 가져옴
        
        return replies.filter { $0.vibeID == vibeID }
    }
    
    func addReply(to vibeID: Int, text: String) async throws -> ReplyUIO {
        
        // 서버에서 vibeID와 text를 가지고 댓글을 저장
        
        let newID = (replies.map { $0.id }.max() ?? 0) + 1
        
        let newUser = SimpleUserUIO(id: 2, nickname: "추가된 사람은 이렇게 추가가 될것이지롱", profileImageURL: nil)
        
        let newReply = ReplyUIO(id: newID, user: newUser, vibeID: vibeID, text: text, isLiked: false, likeCount: 0, createdDate: .now, isMine: true)
        
        replies.append(newReply)
        
        return newReply
    }
    
    func modifyReply(_ reply: ReplyUIO, updatedReply: String) async throws -> ReplyUIO {
        
        // 서버에 replyID, vibeID, text를 가지고 댓글을 수정
        
        guard replies.firstIndex(where: { $0.id == reply.id }) != nil else {
            throw ReplyServiceError.replyNotFound
        }
        
        let newReplyDTO = ReplyUIO(
            id: reply.id,
            user: SimpleUserUIO(id: reply.userID, nickname: reply.userNickname, profileImageURL: reply.userProfileImageURL),
            vibeID: reply.vibeID,
            text: updatedReply,
            isLiked: reply.isLiked,
            likeCount: reply.likeCount,
            createdDate: reply.createdDate,
            isMine: true
        )
        
        return newReplyDTO
    }

    func deleteReply(_ replyID: Int, vibeID: Int) async throws {
        
        // 서버에 replyID를 가지고 댓글을 수정
        
        guard let index = replies.firstIndex(where: { $0.id == replyID }) else {
            throw ReplyServiceError.replyNotFound
        }
        
        replies.remove(at: index)
    }
    
}
