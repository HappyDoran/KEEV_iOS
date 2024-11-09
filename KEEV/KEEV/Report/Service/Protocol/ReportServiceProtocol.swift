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
/// - Todo: 서버와 연결이 이루어지면 sendReport 함수에 서버로 신고를 전송하는 기능을 추가해야합니다.
/// - Author: 라움
protocol ReportServiceProtocol {
    func sendReport(_ report: String)
}
