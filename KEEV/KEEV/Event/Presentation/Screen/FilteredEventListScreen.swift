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
/// - `Duration`: 필터링해서 보여줄 이벤트의 기간을 의미합니다.
/// - `eventGenre`: 이벤트의 장르 입니다. `nil`이 들어갈 수 있습니다.
/// - `eventType`: 이벤트의 타입입니다.
/// - `currentPage`: 현재 페이지 입니다. 스크린이 onAppear되면, `currentPage`의 이벤트 목록을 가져오기 시작합니다.
/// - `maxPage`: 해당 필터의 마지막 페이지 입니다.
/// - `events`: 현재 가지고 있는 배열입니다.
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
///                             FilteredEventListScreen(
///                                 duration: nil,
///                                 eventGenre: eventGenre,
///                                 eventType: eventType,
///                                 currentPage: current + 1,
///                                 maxPage: max,
///                                 events: events
///                             )
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
/// - ToDo: EventService 객체 넣기, duration에 기간 Date를 지정하는 프로퍼티 생성
/// - Author: newJunsung
struct FilteredEventListScreen: View {
    private let duration: Duration?
    private let eventGenre: GenreDTO?
    private let eventType: EventTypeDTO
    
    @State private var currentPage: Int
    private let maxPage: Int
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
        self.currentPage = currentPage > maxPage ? maxPage : currentPage
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
