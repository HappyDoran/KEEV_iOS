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
    func sendCommentReport(vibeId: Int, commentId: String, reason: String) async throws -> (Int, String)
    func sendVibeReport(eventId: String, vibeId: Int, reason: String) async throws -> (Int, String)
    func sendUserReport(userId: Int, reason: String) async throws -> (Int, String)
    func sendEventReport(eventId: String, reason: String) async throws -> (Int, String)
}
