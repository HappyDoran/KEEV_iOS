//
//  ReplyServiceProtocol.swift
//  KEEV
//
//  Created by Doran on 11/25/24.
//

import Foundation

protocol ReplyServiceProtocol: ObservableObject {
    func fetchReplies(for vibeID: Int) async throws -> [ReplyUIO]
    func addReply(to vibeID: Int, text: String) async throws -> ReplyUIO
    func modifyReply(_ reply: ReplyUIO, updatedReply: String) async throws -> ReplyUIO
    func deleteReply(_ replyID: Int) async throws
}

