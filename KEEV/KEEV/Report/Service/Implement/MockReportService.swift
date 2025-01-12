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
    static var layer: LayerType = .service(of: "MockReportService")
    
    /// 댓글 신고하기 함수
    ///
    /// - Parameters:
    ///   - vibeID: 바이브 ID
    ///   - commentID: 댓글 ID
    ///   - reason: 신고 사유
    ///
    /// 댓글 신고하기 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 정상적으로 저장될 경우의 메시지
    ///
    /// - Author: 라움
    func sendReplyReport(vibeID: Int, replyID: Int, reason: String) async throws -> String {
        let response = "Comment report has been successfully submitted."
        return response
    }
    
    /// 바이브 신고하기 함수
    ///
    /// - Parameters:
    ///   - eventID: 이벤트 ID
    ///   - vibeID: 바이브 ID
    ///   - reason: 신고 사유
    ///
    /// 바이브 신고하기 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 정상적으로 저장될 경우의 메시지
    ///
    /// - Author: 라움
    func sendVibeReport(eventID: String, vibeID: Int, reason: String) async throws -> String {
        let response = "Vibe report has been successfully submitted."
        return response
    }
    
    /// 유저 신고하기 함수
    ///
    /// - Parameters:
    ///   - userID: 유저 ID
    ///   - reason: 신고 사유
    ///
    /// 유저 신고하기 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 정상적으로 저장될 경우의 메시지
    ///
    /// - Author: 라움
    func sendUserReport(userID: Int, reason: String) async throws -> String {
        let response = "User report has been successfully submitted."
        return response
    }
    
    /// 이벤트 신고하기 함수
    ///
    /// - Parameters:
    ///   - eventID: 이벤트 ID
    ///   - reason: 신고 사유
    ///
    /// 이벤트 신고하기 함수입니다.
    ///
    /// - Throws: 에러
    /// - Returns: 정상적으로 저장될 경우의 메시지
    ///
    /// - Author: 라움
    func sendEventReport(eventID: String, reason: String) async throws -> String {
        let response = "Event report has been successfully submitted."
        return response
    }
}
