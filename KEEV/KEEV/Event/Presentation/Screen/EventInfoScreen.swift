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
    @Injected private var eventService: any EventServiceProtocol
    @State private var events: [SimpleEventUIO] = SimpleEventUIO.dummies
    @State private var error: String? = nil
    @State private var isLoading: Bool = false
    @State private var selectedEvent: SimpleEventUIO? = nil
    @State private var navigateToEventDetail: Bool = false
    
    @State private var christmasEvents: [SimpleEventUIO] = []
    @State private var rockEvents: [SimpleEventUIO] = []
    @State private var indieEvents: [SimpleEventUIO] = []
    @State private var electronicEvents: [SimpleEventUIO] = []
    @State private var jazzEvents: [SimpleEventUIO] = []
    @State private var recentEvents: [SimpleEventUIO] = []
    
    @State private var currentPage = 0
    private let pageSize = 4
    
    var body: some View {
        VStack {
            MainHeader(selectedEvent: $selectedEvent)
            ScrollView(showsIndicators: false) {
                EventCarouselView().padding(.top, 8)
                themeScrollSectionView(themeName: "최근에 추가된 공연", events: recentEvents)
                themeScrollSectionView(themeName: "성탄절엔 캐롤만 들어야 하나요?", events: christmasEvents, eventFilter: .christmasFilter)
                themeScrollSectionView(themeName: "이달의 락 공연", events: rockEvents, eventFilter: .rockFilter)
                themeScrollSectionView(themeName: "이달의 인디 공연", events: indieEvents, eventFilter: .indieFilter)
            }
        }
        .padding(.bottom, 16)
        .onAppear {
            loadEvents()
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
    private func themeScrollSectionView(themeName: String, events: [SimpleEventUIO], eventFilter: EventFilter? = nil) -> some View {
        VStack(alignment: .leading, spacing: 12){
            NavigationLink {
                FilteredEventListScreen(title: themeName, eventFilter: eventFilter)
            } label : {
                HStack(spacing: 4){
                    Text(themeName)
                        .figmaFont(PretendardFont.title(style: .sm))
                        .foregroundColor(.gray100)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.gray500)
                }
                .padding(.horizontal, 16)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(0..<min(events.count, 5), id: \.self) { index in
                        NavigationLink {
                            EventDetailScreen(simpleEvent: events[index])
                        } label: {
                            EventThumbnailCell(event: events[index])
                        }
                    }
                }
            }
            .safeAreaPadding(.horizontal, 16)
        }
        .padding(.top, 20)
    }
    
    private func loadFilteredEventData(filter: EventFilter) async -> [SimpleEventUIO]? {
        do {
            let paginatedResponse = try await eventService.loadPaginatedFilteringEvents(filter: filter)
            
            return paginatedResponse.contents
        } catch {
            print("Error loading events: \(error)")
            return nil
        }
    }
    
    private func loadEventData() async -> [SimpleEventUIO]? {
        do {
            let response = try await eventService.loadPaginatedEvents(page: 0, size: 10, sort: [(SortCase.createdDate, .descending)])
            return response.contents
            
        } catch {
            print("Error loading events: \(error)")
            return nil
        }
    }
    
    private func loadEvents() {
        Task {
            if let events = await loadFilteredEventData(filter: EventFilter.christmasFilter){
                christmasEvents = events
            }
            
            if let events = await loadFilteredEventData(filter: EventFilter.rockFilter) {
                rockEvents = events
            }
            
            if let events = await loadFilteredEventData(filter: EventFilter.indieFilter) {
                indieEvents = events
            }
            
            if let events = await loadEventData(){
                recentEvents = events
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
