//
//  MockReportService.swift
//  KEEV
//
//  Created by Yune Cho on 11/26/24.
//

import Foundation

/// MockReportService
///
/// 서버와의 통신 없이 UI가 잘 나오는지 확인하기 위한 MockReportService입니다.
///
/// - Author: 라움
class MockReportService: ReportServiceProtocol {
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
    /// - Returns: 신고ID와 정상적으로 저장될 경우의 메시지로 이루어진 튜플
    ///
    /// - Author: 라움
    func sendCommentReport(vibeId: Int, commentId: String, reason: String) async throws -> (Int, String) {
        let response = (103, "Comment report has been successfully submitted.")
        return response
    }
    
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
    /// - Returns: 신고ID와 정상적으로 저장될 경우의 메시지로 이루어진 튜플
    ///
    /// - Author: 라움
    func sendVibeReport(eventId: String, vibeId: Int, reason: String) async throws -> (Int, String) {
        let response = (103, "Vibe report has been successfully submitted.")
        return response
    }
    
    /// 유저 신고하기 함수
    ///
    /// - Parameters:
    ///   - userId: 유저 ID
    ///   - reason: 신고 사유
    ///
    /// 유저 신고하기 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 신고ID와 정상적으로 저장될 경우의 메시지로 이루어진 튜플
    ///
    /// - Author: 라움
    func sendUserReport(userId: Int, reason: String) async throws -> (Int, String) {
        let response = (103, "User report has been successfully submitted.")
        return response
    }
    
    /// 이벤트 신고하기 함수
    ///
    /// - Parameters:
    ///   - eventId: 이벤트 ID
    ///   - reason: 신고 사유
    ///
    /// 이벤트 신고하기 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 신고ID와 정상적으로 저장될 경우의 메시지로 이루어진 튜플
    ///
    /// - Author: 라움
    func sendEventReport(eventId: String, reason: String) async throws -> (Int, String) {
        let response = (103, "Event report has been successfully submitted.")
        return response
    }
}
