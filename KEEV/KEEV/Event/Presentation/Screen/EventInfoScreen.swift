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
    
    @Binding var selectedItem: TabbedItem.RawValue
    
    @State private var events: [SimpleEventUIO] = SimpleEventUIO.dummies
    @State private var error: String? = nil
    @State private var isLoading: Bool = false
    @State private var selectedEvent: SimpleEventUIO? = nil
    @State private var navigateToEventDetail: Bool = false
    
    let filterThemes: [FilterTheme] = [.monthClub, .monthIndie, .monthJazz, .recentEnd, .upcomingKR, .upcoming]
    @State private var filterThemeEvents: [[SimpleEventUIO]] = []
    
    @State private var currentPage = 0
    private let pageSize = 4
    
    var body: some View {
        ScrollViewReader { proxy in
            MainHeader(selectedEvent: $selectedEvent, proxy: proxy)
            
            ScrollView(showsIndicators: false) {
                EventCarouselView().id(0)
                
                themeSectionView(theme: filterThemes, events: filterThemeEvents)
            }
            .onAppear {
                loadFilterThemeEvents()
            }
        }
        .backgroundForKEEV()
    }
}


private extension EventInfoScreen {
    func themeSectionView(theme: [FilterTheme], events: [[SimpleEventUIO]]) -> some View {
        ForEach(0..<theme.count, id: \.self){ index in
            if index < events.count && !events[index].isEmpty {
                VStack(alignment: .leading, spacing: 12){
                    NavigationLink{
                        FilteredEventListScreen(theme: theme[index])
                    } label: {
                        HStack(spacing: 4){
                            Text(theme[index].title)
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
                            ForEach(0..<min(events[index].count, 5), id: \.self) { eventIndex in
                                NavigationLink {
                                    EventDetailScreen(simpleEvent: events[index][eventIndex])
                                } label: {
                                    EventThumbnailCell(event: events[index][eventIndex], showDday: true)
                                }
                            }
                        }
                    }
                    .safeAreaPadding(.horizontal, 16)
                }
                .padding(.top, 20)
            }
            
        }
    }
    
    func loadFilterThemeEvents(theme: FilterTheme) async -> [SimpleEventUIO]? {
        do {
            let paginatedResponse = try await eventService.loadPaginatedFilterThemeEvents(theme: theme, page: 0, size: 10, sort: [(SortCase.startDate, .descending)])
            
            return paginatedResponse.contents
            
        } catch {
            debugPrint("Error loading events: \(error)")
            return nil
        }
    }

    func loadFilterThemeEvents(){
        Task {
            filterThemeEvents = Array(repeating: [], count: filterThemes.count)
            
            for (index, theme) in filterThemes.enumerated() {
                if let events = await loadFilterThemeEvents(theme: theme) {
                    filterThemeEvents[index] = events
                }
            }
        }
    }
    
    func loadEventDataByKeyword(keyword: String) {
        isLoading = true
    }
}


#Preview {
    NavigationStack {
        EventInfoScreen(selectedItem: .constant("info"))
            .backgroundForKEEV()
    }
}
