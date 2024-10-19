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
        VStack{
            HStack {
                TextField("검색어를 넣어주세요" , text : self.$keyword)
                Button(action: {loadEventDataByKeyword(keyword: keyword)}){
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(.black))
                        .padding()
                }
            }

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
    
    private func loadEventDataByKeyword(keyword: String) {
            isLoading = true
            
            Task {
                do {
                    let loadedEvents = try await eventService.loadEventByKeyword(startDate: "20240304", endDate: Date().toString(format: "yyyyMMdd"), keyword: keyword, page: "1", rows: "10")
                    self.events = loadedEvents
                }
                catch {
                    self.error = error.localizedDescription
                }
                isLoading = false
            }
        }

}


#Preview {
    EventView()
}
