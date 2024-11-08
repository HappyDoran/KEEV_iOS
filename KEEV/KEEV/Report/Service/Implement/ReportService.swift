//
//  ReportService.swift
//  KEEV
//
//  Created by Yune Cho on 11/8/24.
//

import Foundation

class ReportService: ReportServiceProtocol {
    func sendReport(_ report: String) {
        print("신고완료 - \(report)")
    }
}

enum ReportType: String {
    case event = "이 공연에 어떤 문제가 있나요?"
    case vibe = "이 게시물에 어떤 문제가 있었나요?"
    case user = "이 사용자에게 어떤 문제가 있었나요?"
    case comment = "이 댓글에 어떤 문제가 있었나요?"
}

extension ReportType {
    var reportList: [String] {
        switch self {
        case .event:
            return ["일정이 잘못된 공연 정보", "부정확한 장소 정보", "공연 취소/변경 미반영된 정보", "중복된 공연 정보", "공식 출처 미확인 정보"]
        case .vibe:
            return ["성적/선정적인 게시물", "공연과 무관한 게시물", "욕설/혐오 발언이 포함된 게시물", "부적절한 거래를 유도하는 게시물", "거짓 정보가 포함된 게시물", "스팸/홍보 도배 게시물"]
        case .user:
            return ["욕설/비방 행위", "스팸/광고 계정", "부적절한 프로필", "사칭 계정", "허위 정보 유포", "개인정보 침해", "부정한 방법으로 이득 추구"]
        case .comment:
            return ["성적/선정적인 댓글", "욕설/혐오 발언이 포함된 댓글", "부적절한 거래를 유도하는 댓글", "거짓정보가 포함된 댓글"]
        }
    }
    
    var etcReportPlaceholder: String {
        return "어떤 문제가 있었는지 작성해주세요."
    }
}
