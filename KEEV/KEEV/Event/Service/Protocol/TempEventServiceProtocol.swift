//
//  TempEventServiceProtocol.swift
//  KEEV
//
//  Created by Yune Cho on 11/22/24.
//

import Foundation

protocol TempEventServiceProtocol: AnyObject {
    func loadPaginatedEvents(page: Int, size: Int, sort: String) async throws -> PaginatedResponse<SimpleEventUIO>
    func loadDetailEvent(id: String) async throws -> DetailEventUIO
}
