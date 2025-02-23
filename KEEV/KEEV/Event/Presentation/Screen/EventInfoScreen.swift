//
//  EventInfoScreen.swift
//  KEEV
//
//  Created by Doran on 11/1/24.
//

import SwiftUI

/// 이벤트 정보에 표시될 스크린
///
/// 이벤트 필터 테마의 갯수에 맞게 2차원 배열을 선언해준 후, 필터에 담긴 필터기준에 맞게 이벤트를 load 해옵니다.
/// 이벤트 갯수가 0일 경우 화면에 표시하지 않습니다.
///
/// - Author: Doran
struct EventInfoScreen: View {
    @Injected private var eventService: any EventServiceProtocol

    @Binding var selectedItem: TabbedItem.RawValue
    @State private var isLoading: Bool = true
    @State private var events: [SimpleEventUIO] = SimpleEventUIO.dummies
    @State private var filterThemeEvents: [[SimpleEventUIO]] = Array(repeating: [], count: FilterTheme.allCases.count)
    let filterThemes: [FilterTheme] = [.monthClub, .monthIndie, .monthJazz, .recentEnd, .upcomingKR, .upcoming]
    
    var body: some View {
        ScrollViewReader { proxy in
            MainHeader(proxy: proxy)
            
            ScrollView(showsIndicators: false) {
                EventCarouselView().id(0)
                if isLoading {
                    ProgressView()
                        .padding(.top, 16)
                }
                else {
                    themeSectionView(theme: filterThemes, events: filterThemeEvents)
                }
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
}

private extension EventInfoScreen {
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
            for (index, theme) in filterThemes.enumerated() {
                if let events = await loadFilterThemeEvents(theme: theme) {
                    filterThemeEvents[index] = events
                }
            }
            isLoading = false
        }
    }
}


#Preview {
    NavigationStack {
        EventInfoScreen(selectedItem: .constant("info"))
            .backgroundForKEEV()
    }
}
