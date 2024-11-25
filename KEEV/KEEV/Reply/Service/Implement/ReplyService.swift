//
//  ReplyService.swift
//  KEEV
//
//  Created by Doran on 11/26/24.
//

class ReplyService: ReplyServiceProtocol {

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
        let newID = (replies.map { $0.id }.max() ?? 0) + 1
        
        let newUser = SimpleUserUIO(id: 2, nickname: "추가된 사람은 이렇게 추가가 될것이지롱", profileImageURL: nil)
        
        let newReply = ReplyUIO(id: newID, user: newUser, vibeID: vibeID, text: text, isLiked: false, likeCount: 0, createdDate: .now)
        
        replies.append(newReply)
        
        return newReply
    }
    
//    func modifyReply(_ reply: ReplyUIO) async throws -> ReplyUIO {
//        <#code#>
//    }
//    
//    func deleteReply(_ replyID: Int) async throws {
//        <#code#>
//    }
    
    
}
