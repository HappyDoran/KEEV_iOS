//
//  EventInfoScreen.swift
//  KEEV
//
//  Created by Doran on 11/1/24.
//

import SwiftUI

/// 이벤트 정보에 표시될 뷰
///
/// PR이후에 삭제될 예정입니다. 어떤 느낌인지 확인 부탁드립니다.
///
/// - Author: Doran
struct EventInfoScreen: View {
    @StateObject private var eventService = EventService()
    @State private var events: [ConcertDTO] = []
    @State private var error: String? = nil
    @State private var isLoading: Bool = false
    @State private var keyword: String = ""
    
    var body: some View {
        ScrollView {
            VStack(){
                HStack(spacing: 8) {
                    ForEach(Array(events.enumerated().prefix(3)), id: \.element.id) { _, event in
                        ThumbnailView(smallThumbnailEvent: event)
                    }
                }.padding(.horizontal, 16)
                
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(events.enumerated().prefix(3)), id: \.element.id) { index, event in
                        HStack(spacing: 8) {
                            Text("\(index + 1)")
                                .figmaFont(PretendardFont.title(style: .lg))
                                .foregroundColor(index == 0 ? Color.brand500 : Color.gray700)
                                .frame(width: 40, height: 40, alignment: .center)
                            EventCellView(eventCellEvent: event)
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 8) {
                        ForEach(events, id: \.self.id) { event in
                            ThumbnailScrollView(bigThumbnailEvent: event)
                        }
                    }
                    .padding(.leading, 16)
                }
                
            }
        }
        .onAppear {
            loadEventData()
        }
    }
}

extension EventInfoScreen {
    private func loadEventData() {
        isLoading = true
        Task {
            do {
                let loadedEvents = try await eventService.loadEvents(
                    startDate: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 4)) ?? Date(),
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
                    rows: 5
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
    EventInfoScreen()
        .backgroundForKEEV()
}
