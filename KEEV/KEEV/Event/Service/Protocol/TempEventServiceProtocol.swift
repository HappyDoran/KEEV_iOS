//
//  TempEventServiceProtocol.swift
//  KEEV
//
//  Created by Yune Cho on 11/22/24.
//

import Foundation

protocol TempEventServiceProtocol: ObservableObject {
    func loadEvents() async throws -> [SimpleEventDTO]
    func loadPaginatedEvents(page: Int, size: Int, sort: String) async throws -> PaginatedResponse<SimpleEventDTO>
    func loadDetailEvent(id: String) async throws -> DetailEventDTO
}
