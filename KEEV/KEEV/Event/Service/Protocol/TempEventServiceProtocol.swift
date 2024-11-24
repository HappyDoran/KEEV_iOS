//
//  TempEventServiceProtocol.swift
//  KEEV
//
//  Created by Yune Cho on 11/22/24.
//

import Foundation

/// EventService를 구현하기 위한 프로토콜
///
/// EventService를 구현하기 위한 프로토콜입니다.
///
/// - ToDo: 향후에 EventServiceProtocol을 이 TempEventServiceProtocol로 교체해야합니다.
/// - Author: 라움
protocol TempEventServiceProtocol: AnyObject {
    func loadPaginatedEvents(page: Int, size: Int, sort: String) async throws -> PaginatedResponse<SimpleEventUIO>
    func loadDetailEvent(id: String) async throws -> DetailEventUIO
}
