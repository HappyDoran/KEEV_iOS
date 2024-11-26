//
//  ReportServiceProtocol.swift
//  KEEV
//
//  Created by Yune Cho on 11/8/24.
//

import Foundation

/// ReportService 구현을 위한 프로토콜
///
/// ReportService 구현을 위한 프로토콜입니다.
///
/// - Author: 라움
protocol ReportServiceProtocol {
    /// 댓글 신고하기 함수
    ///
    /// - Parameters:
    ///   - vibeId: 바이브 ID
    ///   - commentId: 댓글 ID
    ///   - reason: 신고 사유
    ///
    /// 댓글 신고하기 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 정상적으로 저장될 경우의 메시지
    ///
    /// - Author: 라움
    func sendCommentReport(vibeId: Int, commentId: String, reason: String) async throws -> String
    
    /// 바이브 신고하기 함수
    ///
    /// - Parameters:
    ///   - eventId: 이벤트 ID
    ///   - vibeId: 바이브 ID
    ///   - reason: 신고 사유
    ///
    /// 바이브 신고하기 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 정상적으로 저장될 경우의 메시지
    ///
    /// - Author: 라움
    func sendVibeReport(eventId: String, vibeId: Int, reason: String) async throws -> String
    
    /// 유저 신고하기 함수
    ///
    /// - Parameters:
    ///   - userId: 유저 ID
    ///   - reason: 신고 사유
    ///
    /// 유저 신고하기 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 정상적으로 저장될 경우의 메시지
    ///
    /// - Author: 라움
    func sendUserReport(userId: Int, reason: String) async throws -> String
    
    /// 이벤트 신고하기 함수
    ///
    /// - Parameters:
    ///   - eventId: 이벤트 ID
    ///   - reason: 신고 사유
    ///
    /// 이벤트 신고하기 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 정상적으로 저장될 경우의 메시지
    ///
    /// - Author: 라움
    func sendEventReport(eventId: String, reason: String) async throws -> String
}
