//
//  EventView.swift
//  KEEV
//
//  Created by Doran on 10/18/24.
//

import SwiftUI

struct EventView: View {
    @StateObject private var eventService = EventService(networkUtility: NetworkUtility())
    @State private var events: [ConcertDTO] = []
    @State private var error: String? = nil
    @State private var isLoading: Bool = false
    @State private var keyword: String = ""
    
    var body: some View {
        VStack{
            List {
                if isLoading {
                    ProgressView("Loading...")
                } else if let error = error {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else {
                    ForEach(events, id: \.id) { event in
                        Text(event.title)
                    }
                }
            }
            .onAppear {
                loadEventData()
            }
        }
    }
}

extension EventView {
    private func loadEventData() {
        isLoading = true
        Task {
            do {
                let loadedEvents = try await eventService.loadEvents(
                    startDate: "20240304", endDate: Date().toString(format: "yyyyMMdd"), page: "1", rows: "10"
                )
                self.events = loadedEvents
            } catch {
                self.error = error.localizedDescription
            }
            isLoading = false
        }
    }
}


#Preview {
    EventView()
}
