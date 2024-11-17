//
//  FilteredEventListScreen.swift
//  KEEV
//
//  Created by 김준성 on 11/18/24.
//

import SwiftUI

struct FilteredEventListScreen: View {
    private let duration: Duration?
    private let eventGenre: GenreDTO?
    private let eventType: EventTypeDTO
    
    @State private var currentPage: Int
    @State private var maxPage: Int
    @State var events: [SimpleEventUIO]
    
    init(
        duration: Duration,
        eventGenre: GenreDTO?,
        eventType: EventTypeDTO,
        currentPage: Int,
        maxPage: Int,
        events: [SimpleEventUIO] = []
    ) {
        self.duration = duration
        self.eventGenre = eventGenre
        self.eventType = eventType
        self.currentPage = currentPage
        self.maxPage = maxPage
        self.events = events
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                ForEach(events) { event in
                    EventListCell(event: event)
                }
            }
            .padding(16)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension FilteredEventListScreen {
    var title: String {
        var components = [String]()
        
        if let duration {
            components.append(duration.description)
        }
        
        if let eventGenre {
            components.append(eventGenre.name)
        }
        
        components.append(eventType.name)
        
        return components.joined(separator: " ")
    }
}

extension FilteredEventListScreen {
    enum Duration {
        case today
        case thisWeek
        case thisMonth
        case thisYear
    }
}

extension FilteredEventListScreen.Duration: CustomStringConvertible {
    var description: String {
        switch self {
        case .today: return "오늘의"
        case .thisWeek: return "이 주의"
        case .thisMonth: return "이 달의"
        case .thisYear: return "올해의"
        }
    }
}

#Preview {
    NavigationStack {
        FilteredEventListScreen(
            duration: .thisWeek,
            eventGenre: .init(id: 1, name: "장르"),
            eventType: .init(id: 1, name: "타입"),
            currentPage: 0,
            maxPage: 10,
            events: SimpleEventUIO.dummies
        )
    }
}
