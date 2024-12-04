//
//  TotalSearchScreen.swift
//  KEEV
//
//  Created by 김준성 on 11/22/24.
//

import SwiftUI

struct TotalSearchScreen: View {
    @Injected private var searchService: any SearchServiceProtocol
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText: String = ""
    @State private var recentKeywords: [RecentSearch] = []
    @State private var eventSearchStatus: EventSearchStatus = .beforeSearch
    @FocusState private var searchFieldFocus: Bool
    
    @State private var selectedEvent: SimpleEventUIO? = nil
    
    private let searchContent: SearchContent = .event
    
    var body: some View {
        VStack(spacing: 0){
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
        .navigationBarBackButtonHidden()
        .navigationTitle("검색")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.gray100)
                }
            }
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
        .navigationDestination(item: $selectedEvent) { event in
            EventDetailScreen(simpleEvent: event)
        }
        .navigationTitle(searchContent.title)
    }
}

extension TotalSearchScreen {
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
        }
    }
}

#Preview {
    NavigationStack {
        TotalSearchScreen()
    }
}
