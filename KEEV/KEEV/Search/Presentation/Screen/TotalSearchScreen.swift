//
//  TotalSearchScreen.swift
//  KEEV
//
//  Created by 김준성 on 11/22/24.
//

import SwiftUI

struct TotalSearchScreen: View {
    @Injected private var searchService: any SearchServiceProtocol
    
    @State private var searchText: String = ""
    @State private var recentKeywords: [RecentSearch] = []
    @State private var eventSearchStatus: EventSearchStatus = .beforeSearch
    @State private var error: Error? = nil
    @FocusState private var searchFieldFocus: Bool
    
    @State private var selectedEvent: SimpleEventUIO? = nil
    
    private let searchContent: SearchContent = .event
    
    var body: some View {
        VStack(spacing: 0){
            header
                .padding(.bottom, 8)
            
            // MARK: 검색창
            SearchField(text: $searchText,searchStatus: $eventSearchStatus, isFocused: $searchFieldFocus)
            
            switch eventSearchStatus {
                // MARK: 검색 결과가 나오기 전의 뷰
            case .beforeSearch:
                ScrollView(showsIndicators: false){
                    SearchBeforeView(
                        text: $searchText,
                        isFocused: $searchFieldFocus,
                        recentKeywords: $recentKeywords
                    )
                }
                .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
                .padding(.horizontal, 16)
                
                // MARK: 텍스트 필드에 검색을 하는 중인 뷰
            case .searching:
                SearchingView(selectedEvent: $selectedEvent, searchText: $searchText, searchContent: searchContent, error: $error) {
                    handleSearching()
                }
                
                // MARK: 검색 결과가 나온 후의 뷰
            case .afterSearch:
                SearchAfterView(selectedEvent: $selectedEvent, searchText: $searchText, searchContent: searchContent, error: $error){
                    handleAfterSearch()
                }
                .padding(.horizontal, 16)
                .onAppear {
                    searchService.setRecentSearch(searchItem: RecentSearch(term: searchText, date: .now))
                }
            }
            Spacer()
        }
        .alertForError($error)
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
        .navigationDestination(item: $selectedEvent) { event in
            EventDetailScreen(simpleEvent: event)
        }
        .navigationTitle(searchContent.title)
    }
}

private extension TotalSearchScreen {
    var header: some View {
        HStack {
            Text("검색")
                .figmaFont(PretendardFont.title(style: .xl))
                .foregroundStyle(Color.gray100)
            
            Spacer()
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
    }
}

private extension TotalSearchScreen {
    // MARK: 검색을 하는 과정을 표현한 함수
    func searchCase()-> EventSearchStatus {
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
    
    func handleSearching() {
        switch searchContent {
        case .event:
            debugPrint("searchResult 이동")
        case .vibe:
            debugPrint("글쓰기 이동")
        }
    }
    
    func handleAfterSearch() {
        switch searchContent {
        case .event:
            debugPrint("Event Detail 이동")
        case .vibe:
            debugPrint("글쓰기 이동")
        }
    }
}

#Preview {
    NavigationStack {
        TotalSearchScreen()
    }
}
