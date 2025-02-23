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
/// - `title`: 헤더에 보여줄 타이틀
/// - `EventFilter`: 어떠한 필터링 이벤트인지를 의미합니다.
///
/// 여기서 피그마의 이벤트 정보 스크린에서 이미 필터링된 이벤트의 일부를 보여주고 있다고 가정해보겠습니다.
///
/// 그렇다면 사용법은 아래와 같습니다:
///
/// ```swift
/// struct TempInfoScreen: some View {
///     private let eventGenre = GenreDTO(id: 1, name: "J-POP")
///     private let eventType = EventTypeDTO(id: 2, name: "페스티벌")
///     @State private var currentPage: Int? = nil
///     @State private var maxPage: Int? = nil
///     @State private var events = [SimpleEventUIO]()
///
///     private let service = EventService()
///
///     var body: some View {
///         if let max = maxPage,
///            let current = currentPage {
///                 if !events.isEmpty {
///                     VStack {
///                         NavigationLink {
///                             FilteredEventListScreen(title: themeName, eventFilter: eventFilter)
///                         } label: {
///                             Text("\(eventGenre.name) \(eventType.name)")
///                         }
///                         // 이벤트 목록을 나열하는 코드.
///                     }
///                 } else {
///                     Text("이벤트가 없어요...😭")
///                 }
///            } else {
///                 ProgressView()
///            }
///     }
///     .onAppear {
///         Task.detached {
///             let (current, max, fetched) = await service.fetchFilteredEvents()
///             currentPage = current
///             maxPage = max
///             events = fetched
///         }
///     }
/// }
/// ```
///
/// 이런 식으로 외부에서 값을 받아서 페이지에 대한 정보를 얻고 그에 대한 정보들을 주입하면 됩니다.
/// 위의 코드에서 `current + 1`을 주입한 이유는 다음 페이지부터 정보를 가져와야하기 때문입니다.
///
/// - ToDo: EventService 객체 넣기, duration에 기간 Date를 지정하는 프로퍼티 생성, NavigationLink에 Destination 설정
/// - Author: newJunsung
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
