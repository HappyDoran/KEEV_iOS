//
//  ReportService.swift
//  KEEV
//
//  Created by Yune Cho on 11/8/24.
//

import Foundation

/// 신고하기를 위한 ReportService
///
/// 신고하기 기능을 위한 ReportService입니다.
///
/// - Author: 라움
class ReportService: ReportServiceProtocol {
    private let networkUtility = NetworkUtility()
    private let tokenUtility = TokenUtility.shared
    private let jsonDecoder = JSONDecoder()
    
    private struct ReportResponse: Decodable {
        let id: Int
        let message: String
    }
    
    func sendReplyReport(vibeID: Int, replyID: Int, reason: String) async throws -> String {
        let accessToken = try await getAccessToken()
        let router = ReportHTTPRequestRouter.replyReport(
            token: accessToken,
            vibeID: vibeID,
            replyID: replyID,
            reason: reason
        )
        
        let data = try await networkUtility.request(router: router)
        
        let response = try jsonDecoder.decode(ReportResponse.self, from: data)
        return response.message
    }
    
    func sendVibeReport(eventID: String, vibeID: Int, reason: String) async throws -> String {
        let accessToken = try await getAccessToken()
        let router = ReportHTTPRequestRouter.vibeReport(
            token: accessToken,
            eventID: eventID,
            vibeID: vibeID,
            reason: reason
        )
        
        let data = try await networkUtility.request(router: router)
        
        let response = try jsonDecoder.decode(ReportResponse.self, from: data)
        return response.message
    }
    
    func sendUserReport(userID: Int, reason: String) async throws -> String {
        let accessToken = try await getAccessToken()
        let router = ReportHTTPRequestRouter.userReport(
            token: accessToken,
            userID: userID,
            reason: reason
        )
        
        let data = try await networkUtility.request(router: router)
        
        let response = try jsonDecoder.decode(ReportResponse.self, from: data)
        return response.message
    }
    
    func sendEventReport(eventID: String, reason: String) async throws -> String {
        let accessToken = try await getAccessToken()
        let router = ReportHTTPRequestRouter.eventReport(
            token: accessToken,
            eventID: eventID,
            reason: reason
        )
        
        let data = try await networkUtility.request(router: router)
        
        let response = try jsonDecoder.decode(ReportResponse.self, from: data)
        return response.message
    }
}

extension ReportService {
    private func getAccessToken() async throws -> String {
        try await tokenUtility.fetchToken(for: .access)
    }
}

/// 신고 타입
///
/// 신고하기 기능이 필요한 타입들을 분류해놓은 열거형입니다.
///
/// rawValue로는 신고하기 화면 상단에 나오는 질문 문자열을 가지고 있습니다.
///
/// - Author: 라움
enum ReportType: CustomStringConvertible {
    case event(eventID: String)
    case vibe(eventID: String, vibeID: Int)
    case user(userID: Int)
    case reply(vibeID: Int, replyID: Int)
    
    var description: String {
        switch self {
        case .event:
            "이 공연에 어떤 문제가 있나요?"
        case .vibe:
            "이 게시물에 어떤 문제가 있었나요?"
        case .user:
            "이 사용자에게 어떤 문제가 있었나요?"
        case .reply:
            "이 댓글에 어떤 문제가 있었나요?"
        }
    }
}

extension ReportType {
    /// 신고 타입에 따른 신고 내용 목록들을 담은 문자열 배열입니다.
    var reportList: [String] {
        switch self {
        case .event:
            return ["일정이 잘못된 공연 정보", "부정확한 장소 정보", "공연 취소/변경 미반영된 정보", "중복된 공연 정보", "공식 출처 미확인 정보"]
        case .vibe:
            return ["성적/선정적인 게시물", "공연과 무관한 게시물", "욕설/혐오 발언이 포함된 게시물", "부적절한 거래를 유도하는 게시물", "거짓 정보가 포함된 게시물", "스팸/홍보 도배 게시물"]
        case .user:
            return ["욕설/비방 행위", "스팸/광고 계정", "부적절한 프로필", "사칭 계정", "허위 정보 유포", "개인정보 침해", "부정한 방법으로 이득 추구"]
        case .reply:
            return ["성적/선정적인 댓글", "욕설/혐오 발언이 포함된 댓글", "부적절한 거래를 유도하는 댓글", "거짓정보가 포함된 댓글"]
        }
    }
    
    /// 신고 내용을 '기타'로 선택했을 경우에 나타나는 텍스트 필드에 보이는 플레이스홀더입니다.
    var etcReportPlaceholder: String {
        return "어떤 문제가 있었는지 작성해주세요."
    }
}

extension ReportType: Hashable {
    static func == (lhs: ReportType, rhs: ReportType) -> Bool {
        lhs.description == rhs.description
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.description)
    }
}
