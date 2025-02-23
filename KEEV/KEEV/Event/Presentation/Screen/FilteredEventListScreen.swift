//
//  FilteredEventListScreen.swift
//  KEEV
//
//  Created by 김준성 on 11/18/24.
//

import SwiftUI

/// 필터링된 이벤트를 보여주는 뷰 입니다.
///
/// 필터링된 이벤트를 보여주기 위해선, 다음과 같은 프로퍼티가 필요합니다.
///
/// - `theme`: 필터링 테마
///
/// page가 onAppear되면 currentPage와 totalPage를 매개변수로 pagination의 이벤트를 불러옵니다.
/// 그 이후 스크롤을 하면서 보여지는 이벤트의 인덱스와 현재 이벤트의 갯수-1과 동일해지면, currentPage를 1더해서 pagination의 이벤트를 불러옵니다.
///
/// - Author: Doran
struct FilteredEventListScreen: View {
    @Injected private var eventService: any EventServiceProtocol
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentPage = 0
    @State private var totalPages = 1
    private let pageSize = 7
    private let theme: FilterTheme
    @State private var events: [SimpleEventUIO] = []
    @State private var error: Error? = nil
    
    init(theme: FilterTheme){
        self.theme = theme
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
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
            }
            .padding(16)
        }
        .navigationTitle(theme.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 24){
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.gray100)
                    }
                }
            }
        }
        .onAppear {
            if(currentPage == 0){
                Task {
                    await loadEvents(page: currentPage)
                }
            }
        }
        .alertForError($error)
    }
}

extension FilteredEventListScreen {
    private func loadEvents(page: Int) async {
        do {
            let response: PaginatedResponse<SimpleEventUIO>
            response = try await eventService.loadPaginatedFilterThemeEvents(theme: theme, page: page, size: pageSize, sort: [(SortCase.startDate, .descending)])
            events.append(contentsOf: response.contents)
            totalPages = response.totalPages
            currentPage += 1
            
        } catch let failToLoadEvent {
            error = failToLoadEvent
        }
    }
}

#Preview {
    NavigationStack {
        FilteredEventListScreen(theme: .monthClub)
    }
}
