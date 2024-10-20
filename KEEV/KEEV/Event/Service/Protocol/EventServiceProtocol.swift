//
//  EventServiceProtocol.swift
//  KEEV
//
//  Created by Doran on 10/20/24.
//

import SwiftUI

protocol EventServiceProtocol: ObservableObject {
    func loadEvents(startDate: Date, endDate: Date, page: Int, rows: Int) async throws -> [ConcertDTO]
    func loadEventByKeyword(startDate: Date, endDate: Date, keyword: String, page: Int, rows: Int) async throws -> [ConcertDTO]
}
