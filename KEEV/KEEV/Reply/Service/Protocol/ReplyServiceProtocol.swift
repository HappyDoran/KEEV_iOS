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
    /// 바이브에 대한 댓글을 가져오는 함수
    ///
    /// - Parameters:
    ///   - vibeID : 바이브 아이디
    ///
    /// 서버에 vibeID를 request 하고 바이브에 대한 댓글을 가져옵니다.
    ///
    /// - Returns: 바이브에 대한 댓글들
    ///
    /// - Author: Doran
    func fetchReplies(for vibeID: Int) async throws -> [ReplyUIO]
    
    /// 바이브에 댓글을 추가하는 함수
    ///
    /// - Parameters:
    ///   - vibeID: 바이브 아이디
    ///   - text: 추가하고자 하는 텍스트
    ///
    /// 서버에 vibeID와 추가하고자하는 Text를 request하고 바이브에 댓글을 작성합니다.
    ///
    /// - Returns: 추가한 댓글
    ///
    /// - Author: Doran
    func addReply(to vibeID: Int, text: String) async throws -> ReplyUIO
    
    /// 바이브에 대한 댓글을 수정하는 함수
    ///
    /// - Parameters:
    ///   - reply: 수정할 하는 댓글 객체
    ///   - updatedReply: 반영되는 댓글 텍스트
    ///
    /// - Throws: 수정할 댓글을 찾지 못할 경우 에러
    /// - Returns: 수정 완료한 객체
    ///
    /// - Author: Doran
    func modifyReply(_ reply: ReplyUIO, updatedReply: String) async throws -> ReplyUIO
    
    /// 바이브에 대한 댓글을 삭제하는 함수
    ///
    /// - Parameters:
    ///   - replyID: 삭제할 댓글 아이디
    ///
    /// - Throws: 삭제할 댓글을 찾지 못할 경우 에러
    ///
    /// - Author: Doran
    func deleteReply(_ replyID: Int, vibeID: Int) async throws
}

