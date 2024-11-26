//
//  ReplyServiceProtocol.swift
//  KEEV
//
//  Created by Doran on 11/25/24.
//

import Foundation

/// ReplyService에서 채택할 프로토콜
///
/// 댓글 읽기, 쓰기, 수정, 삭제에 대한 함수가 명시되어있다.
///
/// - Author: Doran
protocol ReplyServiceProtocol: ObservableObject {
    func fetchReplies(for vibeID: Int) async throws -> [ReplyUIO]
    func addReply(to vibeID: Int, text: String) async throws -> ReplyUIO
    func modifyReply(_ reply: ReplyUIO, updatedReply: String) async throws -> ReplyUIO
    func deleteReply(_ replyID: Int) async throws
}

