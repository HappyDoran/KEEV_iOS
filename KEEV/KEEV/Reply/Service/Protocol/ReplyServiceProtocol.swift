//
//  ReplyServiceProtocol.swift
//  KEEV
//
//  Created by Doran on 11/25/24.
//

import Foundation

protocol ReplyServiceProtocol: ObservableObject {
    func createReply() async throws  -> ReplyUIO
    func readReply() async throws -> ReplyUIO
    func updateReply() async throws -> ReplyUIO
    func deleteReply() async throws -> ReplyUIO
}
