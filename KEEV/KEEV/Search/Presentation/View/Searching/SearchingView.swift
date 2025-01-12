//
//  Searching.swift
//  KEEV
//
//  Created by Doran on 11/5/24.
//

import SwiftUI

struct SearchingView: View {
    @Injected private var searchService: any SearchServiceProtocol
    
    @Environment(\.dismiss) private var dismiss
    @State private var events: [SimpleEventUIO] = []
    private let currentPage = 0
    private let pageSize = 5
    
    @Binding private var selectedEvent: SimpleEventUIO?
    @Binding private var searchText: String
    var searchContent: SearchContent
    @Binding private var error: Error?
    private let onClick: () -> Void
    
    init(selectedEvent: Binding<SimpleEventUIO?> = Binding.constant(nil), searchText: Binding<String>, searchContent: SearchContent, error: Binding<Error?>, onClick: @escaping ()-> Void) {
        self._selectedEvent = selectedEvent
        self._searchText = searchText
        self.searchContent = searchContent
        self._error = error
        self.onClick = onClick
    }
    
    var body: some View {
        VStack(spacing: 0) {
            searching
                .onAppear(perform: {
                    if searchText.count >= 2 {
                        loadSearchResult()
                    }
                })
                .onChange(of: searchText) { _, newValue in
                    if newValue.count >= 2 {
                        loadSearchResult()
                    }
                }
        }
    }
}

extension SearchingView {
    // MARK: searchText에 텍스트를 입력하는 동안에 나오는 검색 결과
    private var searching: some View {
        VStack(spacing: 0) {
            ForEach(events.indices, id: \.self) { index in
                SearchCell(text: events[index].name)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .onTapGesture {
                        selectedEvent = events[index]
                        if searchContent == .vibe {
                            dismiss()
                        }
                        onClick()
                    }
            }
        }
        .padding(.top, 12)
    }
}

extension SearchingView {
    private func loadSearchResult() {
        Task {
            do {
                switch searchContent {
                case .event:
                    let allEvents = try await searchService.searchEventByName(name: searchText, size: pageSize, page: currentPage).contents
                    events = allEvents
                case .vibe:
                    let allEvents = try await searchService.searchEventByNameWhenAddVibe(name: searchText, size: pageSize, page: currentPage).contents
                    events = allEvents
                }
            } catch let failToLoadSearchResult {
                error = failToLoadSearchResult
            }
        }
    }
}

#Preview {
    SearchingView(
        searchText: .constant("칸예"),
        searchContent: .event,
        error: .constant(nil),
        onClick: {}
    )
    .backgroundForKEEV()
}
