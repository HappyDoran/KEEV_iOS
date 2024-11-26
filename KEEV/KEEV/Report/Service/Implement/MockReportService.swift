//
//  MockReportService.swift
//  KEEV
//
//  Created by Yune Cho on 11/26/24.
//

import Foundation

class MockReportService: ReportServiceProtocol {
    func sendCommentReport(vibeId: Int, commentId: String, reason: String) async throws -> (Int, String) {
        let response = (103, "Comment report has been successfully submitted.")
        return response
    }
    
    func sendVibeReport(eventId: String, vibeId: Int, reason: String) async throws -> (Int, String) {
        let response = (103, "Vibe report has been successfully submitted.")
        return response
    }
    
    func sendUserReport(userId: Int, reason: String) async throws -> (Int, String) {
        let response = (103, "User report has been successfully submitted.")
        return response
    }
    
    func sendEventReport(eventId: String, reason: String) async throws -> (Int, String) {
        let response = (103, "Event report has been successfully submitted.")
        return response
    }
}
