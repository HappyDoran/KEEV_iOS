//
//  EventService.swift
//  KEEV
//
//  Created by Doran on 10/19/24.
//

import SwiftUI
import Foundation

@MainActor
class EventService: ObservableObject {
    @ObservationIgnored
    private var networkUtility: NetworkUtility
    
    init(networkUtility: NetworkUtility) {
        self.networkUtility = networkUtility
    }
    
    func loadEvents(startDate: String, endDate: String, page: String, rows: String) async throws -> [ConcertDTO] {
        let router = EventRouter.getEvents(
            stdate: startDate,
            eddate: endDate,
            cpage: page,
            rows: rows
        )
        
        do {
            let data: Data = try await networkUtility.xmlRequest(router: router)
            
            let parser = EventXMLParser()
            let events = parser.parse(data)

            return events
        } catch {
            print("\(error)")
            throw error
        }
    }
}
