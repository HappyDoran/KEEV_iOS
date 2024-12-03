//
//  CarouselSecondView.swift
//  KEEV
//
//  Created by Doran on 11/30/24.
//

import SwiftUI

struct CarouselSecondView: View {
    @Injected private var eventService: any EventServiceProtocol
//    @State private var events: [SimpleEventUIO] = SimpleEventUIO.dummies
    
    @State private var currentPage = 0
    @State private var totalPages = 1
    private let pageSize = 7
    @State private var events: [SimpleEventUIO] = []
    
    var body: some View {
        LazyVStack(spacing: 0){
            Rectangle().frame(height: 15).foregroundColor(.grayBG800)
            ForEach(events.indices, id: \.self) { index in
                NavigationLink {
                    EventDetailScreen(simpleEvent: events[index])
                } label: {
                    EventListCell(event: events[index])
                }
                .onAppear {
                    if index == events.count - 1 && currentPage < totalPages {
                        Task {
                            await loadEvents(page: currentPage)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .onAppear{
            if(currentPage == 0){
                Task {
                    await loadEvents(page: currentPage)
                }
            }
        }
    }
}

extension CarouselSecondView {
    private func loadEvents(page: Int) async {
        do {
            let response = try await eventService.loadPaginatedFilteringEvents(
                filter: EventFilter(eventFilter: .monthFilter, page: currentPage, size: pageSize))
            
            events.append(contentsOf: response.contents)
            
            totalPages = response.totalPages
            currentPage += 1
            
        } catch {
            print(error)
        }
    }
}

#Preview {
    ScrollView {
        CarouselSecondView()
    }
}
