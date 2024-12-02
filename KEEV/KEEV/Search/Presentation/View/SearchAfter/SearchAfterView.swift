//
//  SearchAfter.swift
//  KEEV
//
//  Created by Doran on 11/4/24.
//

import SwiftUI

/// 검색 결과가 나온 후의 뷰
///
///  textField에서 return 버튼을 클릭한 후에 textfield에 해당하는 검색 결과가 나옵니다.
///
/// - Author: Doran
struct SearchAfterView: View {
    @Injected private var searchService: any SearchServiceProtocol
    
    @State private var events: [SimpleEventUIO] = []
    @State private var totalEvents = 0
    @State private var currentPage = 0
    @State private var totalPages = 0
    private let pageSize = 10
    
    @Binding private var selectedEvent: SimpleEventUIO?
    @Binding private var searchText: String
    private var searchContent: SearchContent
    private let onClick: () -> Void
    
    init(selectedEvent: Binding<SimpleEventUIO?> = Binding.constant(nil), searchText: Binding<String>, searchContent: SearchContent, onClick: @escaping ()-> Void) {
        self._selectedEvent = selectedEvent
        self._searchText = searchText
        self.searchContent = searchContent
        self.onClick = onClick
    }
    
    var body: some View {
        VStack(spacing: 0){
            recentSearchHeader
            if events.isEmpty {
                searchEmpty
            } else {
                searchResult
            }
        }
        .onAppear {
            loadSearchResult()
        }
    }
}

extension SearchAfterView {
    // MARK: 헤더 뷰
    private var recentSearchHeader: some View {
        HStack(spacing: 0) {
            Group {
                HStack(spacing: 0){
                    Text("\(totalEvents)")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                        .foregroundColor(.gray100)
                    Text(" 건의 검색 결과")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                        .foregroundColor(.gray500)
                }
            }
            Spacer()
        }
        .frame(height: 33)
        .padding(.top, 12)
    }
    
    private var searchEmpty: some View {
        VStack(spacing: 4) {
            Spacer()
            Text("공연이 없어요...")
                .figmaFont(PretendardFont.title(style: .sm))
                .foregroundStyle(.gray500)
            Text("찾으시는 공연에 대해\n hmhz.studio@gmail.com으로 연락주세요.")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium)))
                .multilineTextAlignment(.center)
                .foregroundStyle(.gray500)
            Spacer()
            Spacer()
        }
    }
    
    // MARK: 검색 결과 뷰
    private var searchResult: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(events.indices, id: \.self) { index in
                    EventListCell(event: events[index])
                        .onTapGesture {
                            selectedEvent = events[index]
                            onClick()
                        }
                        .onAppear {
                            guard let index = events.firstIndex(where: { $0.id == events[index].id }) else { return }
                            
                            if index == events.count - 1 && currentPage < totalPages {
                                addSearchResult()
                            }
                        }
                }
            }
        }
    }
}

extension SearchAfterView {
    private func loadSearchResult() {
        Task {
            do {
                switch searchContent {
                case .event:
                    let paginatedResponse = try await searchService.searchEventByName(name: searchText, size: pageSize, page: currentPage)
                    let allEvents = paginatedResponse.contents
                    totalEvents = paginatedResponse.totalElements
                    events = allEvents
                case .vibe:
                    let paginatedResponse = try await searchService.searchEventByNameWhenAddVibe(name: searchText, size: pageSize, page: currentPage)
                    let allEvents = paginatedResponse.contents
                    totalEvents = paginatedResponse.totalElements
                    events = allEvents
                }
                totalPages = Int(ceil(Double(totalEvents) / Double(pageSize)))
                currentPage += 1
            } catch {
                print(error)
            }
        }
    }
    
    private func addSearchResult() {
        Task {
            do {
                switch searchContent {
                case .event:
                    let newEvents = try await searchService.searchEventByName(name: searchText, size: pageSize, page: currentPage).contents
                    events.append(contentsOf: newEvents)
                case .vibe:
                    let newEvents = try await searchService.searchEventByNameWhenAddVibe(name: searchText, size: pageSize, page: currentPage).contents
                    events.append(contentsOf: newEvents)
                }
                currentPage += 1
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    SearchAfterView(
        searchText: .constant("칸예"),
        searchContent: .event,
        onClick: {}
    )
    .backgroundForKEEV()
}
