//
//  EventSearchScreen.swift
//  KEEV
//
//  Created by Doran on 11/2/24.
//

import SwiftUI

/// 이벤트 검색 화면을 검색하기 전에 나오는 뷰와 검색한 후의 뷰를 구분하기 위해서 정의한 열거형
///
/// 검색 결과가 나오기 전까지는 .beforeSearch
///
/// - Author: Doran
enum EventSearchStatus {
    case beforeSearch
    case searching
    case afterSearch
}

/// 이벤트 검색에 해당하는 것을 전반적으로 담당하는 스크린
///
/// - Parameters:
///   - isPresented: 시트가 올라와있는지 아닌지를 판별하는 Bool 타입 변수
///
/// - Author: Doran
struct SearchScreen: View {
    @Injected private var searchService: any SearchServiceProtocol
    
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    @State private var recentKeywords: [RecentSearch] = []
    @State private var eventSearchStatus: EventSearchStatus = .beforeSearch
    @FocusState private var searchFieldFocus: Bool
    
    @Binding private var selectedEvent: SimpleEventUIO?
    
    private let searchContent: SearchContent
    
    init(selectedEvent: Binding<SimpleEventUIO?> = Binding.constant(nil), searchContent: SearchContent) {
        self._selectedEvent = selectedEvent
        self.searchContent = searchContent
    }
    
    var body: some View {
        VStack(spacing: 0){
            // MARK: 헤더
            SearchHeader(title: searchContent.title)
            
            // MARK: 검색창
            SearchField(text: $searchText,searchStatus: $eventSearchStatus, isFocused: $searchFieldFocus)
            
            switch eventSearchStatus {
                // MARK: 검색 결과가 나오기 전의 뷰
            case .beforeSearch:
                SearchBeforeView(
                    text: $searchText,
                    isFocused: $searchFieldFocus,
                    recentKeywords: $recentKeywords
                )
                .padding(.horizontal, 16)
                
                // MARK: 텍스트 필드에 검색을 하는 중인 뷰
            case .searching:
                SearchingView(selectedEvent: $selectedEvent, searchText: $searchText, searchContent: searchContent){
                    handleSearching()
                }
                
                // MARK: 검색 결과가 나온 후의 뷰
            case .afterSearch:
                SearchAfterView(selectedEvent: $selectedEvent, searchText: $searchText, searchContent: searchContent){
                    handleAfterSearch()
                }
                .padding(.horizontal, 16)
                .onAppear {
                    searchService.setRecentSearch(searchItem: RecentSearch(term: searchText, date: .now))
                }
            }
            Spacer()
        }
        .onChange(of: [searchFieldFocus, searchText.isEmpty]) {
            eventSearchStatus = searchCase()
        }
        .onChange(of: eventSearchStatus) {
            recentKeywords = searchService.getRecentSearch().reversed()
        }
        .onAppear(perform: {
            recentKeywords = searchService.getRecentSearch().reversed()
        })
        .backgroundForKEEV()
    }
}

extension SearchScreen {
    // MARK: 검색을 하는 과정을 표현한 함수
    private func searchCase()-> EventSearchStatus {
        if !searchFieldFocus && searchText.isEmpty {
            return .beforeSearch
        }
        else if searchFieldFocus && searchText.isEmpty {
            return .beforeSearch
        }
        else if searchFieldFocus && !searchText.isEmpty {
            return .searching
        }
        else {
            return .afterSearch
        }
    }
    
    private func handleSearching() {
        switch searchContent {
        case .event:
            print("searchResult 이동")
        case .vibe:
            print("글쓰기 이동")
        }
    }
    
    private func handleAfterSearch() {
        switch searchContent {
        case .event:
            print("Event Detail 이동")
        case .vibe:
            print("글쓰기 이동")
            dismiss()
        }
    }
}

#Preview {
    SearchScreen(searchContent: .event)
        .backgroundForKEEV()
}
