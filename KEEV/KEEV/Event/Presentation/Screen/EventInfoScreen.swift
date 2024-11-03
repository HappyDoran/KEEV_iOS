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
    
    var body: some View {
        VStack {
            MainHeader()
            ScrollView {
                thumbnailSection.padding(.top, 16)
                eventListSection.padding(.top, 48)
                horizontalScrollSection
            }
            .backgroundForKEEV()
        }
        .onAppear {
            loadEventData()
        }
        .backgroundForKEEV()
    }
}

extension EventInfoScreen {
    private var thumbnailSection: some View {
        HStack(spacing: 8) {
            ForEach(Array(events.enumerated().prefix(3)), id: \.element.id) { _, event in
                EventThumbnailCell(event: event)
            }
        }.padding(.horizontal, 16)
    }
    
    private var eventListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(events.enumerated().prefix(3)), id: \.element.id) { index, event in
                HStack(spacing: 8) {
                    Text("\(index + 1)")
                        .figmaFont(PretendardFont.title(style: .lg))
                        .foregroundColor(index == 0 ? Color.brand500 : Color.gray700)
                        .frame(width: 40, height: 40, alignment: .center)
                    EventCell(event: event)
                }
            }
        }.padding(.horizontal, 16)
    }
    
    private var horizontalScrollSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(events, id: \.self.id) { event in
                    BigEventThumbnailCell(event: event)
                }
            }.padding(.leading, 16)
        }
    }
}

extension EventInfoScreen {
    private func loadEventData() {
        isLoading = true
        Task.detached {
            do {
                let loadedEvents = try await eventService.loadEvents(
                    startDate: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 4)) ?? Date(),
                    endDate: Date(),
                    page: 1,
                    rows: 10
                )
                await MainActor.run {
                    self.events = loadedEvents
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    private func loadEventDataByKeyword(keyword: String) {
        isLoading = true
        Task.detached {
            do {
                let loadedEvents = try await eventService.loadEventByKeyword(
                    startDate: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 4)) ?? Date(),
                    endDate: Date(),
                    keyword: keyword,
                    page: 1,
                    rows: 5
                )
                await MainActor.run {
                    self.events = loadedEvents
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
}


#Preview {
    EventInfoScreen()
//        .backgroundForKEEV()
}
