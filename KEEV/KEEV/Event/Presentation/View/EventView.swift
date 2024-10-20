//
//  EventView.swift
//  KEEV
//
//  Created by Doran on 10/18/24.
//

import SwiftUI

struct EventView: View {
    @StateObject private var eventService = EventService()
    @State private var events: [ConcertDTO] = []
    @State private var error: String? = nil
    @State private var isLoading: Bool = false
    @State private var keyword: String = ""
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

extension EventView {
    private func loadEventData() {
        isLoading = true
        Task {
            do {
                let loadedEvents = try await eventService.loadEvents(
                    startDate: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 4)) ?? Date(),
                    endDate: Date(),
                    page: 1,
                    rows: 10
                )
                DispatchQueue.main.async {
                    self.events = loadedEvents
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
            isLoading = false
        }
    }
    private func loadEventDataByKeyword(keyword: String) {
        isLoading = true
        Task {
            do {
                let loadedEvents = try await eventService.loadEventByKeyword(
                    startDate: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 4)) ?? Date(),
                    endDate: Date(),
                    keyword: keyword,
                    page: 1,
                    rows: 10
                )
                DispatchQueue.main.async {
                    self.events = loadedEvents
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
            isLoading = false
        }
    }
}


#Preview {
    EventView()
}
