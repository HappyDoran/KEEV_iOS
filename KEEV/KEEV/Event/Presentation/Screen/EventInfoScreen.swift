//
//  EventInfoScreen.swift
//  KEEV
//
//  Created by Doran on 11/1/24.
//

import SwiftUI

/// 어느 스크린에서 검색창을 띄우는지 정의하는 열거형
///
/// - event: 이벤트 정보 스크린에서 검색창을 띄우는 경우
/// - vibe: 바이브를 생성하는 스크린에서 검색창을 띄우는 경우
///
/// - Author: Doran
enum SearchContent {
    case event
    case vibe
    
    ///  유형에 따른 헤더 타이틀을 반환
    ///
    /// - Returns: 헤더 타이틀에 해당하는 문자열
    var title: String {
        switch self {
        case .event: return "검색"
        case .vibe: return "공연 찾기"
        }
    }
}

/// 이벤트 정보에 표시될 스크린
///
/// - Author: Doran
struct EventInfoScreen: View {
//    @Injected private var eventService: any EventServiceProtocol
    @State private var events: [SimpleEventUIO] = SimpleEventUIO.dummies
    @State private var error: String? = nil
    @State private var isLoading: Bool = false
    @State private var selectedEvent: SimpleEventUIO? = nil
    @State private var navigateToEventDetail: Bool = false
    
    var body: some View {
        VStack {
            MainHeader(selectedEvent: $selectedEvent)
            ScrollView(showsIndicators: false) {
                thumbnailSection.padding(.top, 16).padding(.horizontal, 16)
                eventListSection.padding(.top, 48).padding(.horizontal, 16)
                horizontalScrollSection.padding(.leading, 16)
            }
        }
        .onAppear {
            let eventService = MockEventService()
            Task {
                do {
                    let response = try await eventService.loadPaginatedFilteredEvents()
                    for event in response.contents {
                        print("Event Name: \(event.name),  Start Date: \(event.startDate), EventID: \(event.id)")
                    }
                } catch {
                    print("Error loading events: \(error)")
                }
            }
        }
        .backgroundForKEEV()
    }
}

extension EventInfoScreen {
    // MARK: 이벤트 썸네일 뷰
    private var thumbnailSection: some View {
        HStack(spacing: 8) {
            ForEach(0..<min(events.count, 3), id: \.self) { index in
                NavigationLink {
                    EventDetailScreen(simpleEvent: events[index])
                } label: {
                    EventThumbnailCell(event: events[index])
                }
            }
        }
    }
    
    // MARK: 이벤트 리스트 뷰
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
        }
    }
    
    // MARK: 이벤트 횡스크롤 썸네일 뷰
    private var horizontalScrollSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(events) { event in
                    BigEventThumbnailCell(event: event)
                }
            }
        }
    }
}

extension EventInfoScreen {
    private func loadEventData() {
        isLoading = true
        Task.detached {
                await MainActor.run {
                    self.events = SimpleEventUIO.dummies
                    self.isLoading = false
                }
        }
    }
    
    private func loadEventDataByKeyword(keyword: String) {
        isLoading = true
    }
}


#Preview {
    NavigationStack {
        EventInfoScreen()
            .backgroundForKEEV()
    }
}
