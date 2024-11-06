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
    @State private var searchText: String = ""
    @State private var eventSearchStatus: EventSearchStatus = .beforeSearch
    @FocusState private var searchFieldFocus: Bool
    
    @Binding private var selectedEvent: EventDTO?
    var searchContent: SearchContent
    
    init(selectedEvent: Binding<EventDTO?> = Binding.constant(nil), searchContent: SearchContent) {
        self._selectedEvent = selectedEvent
        self.searchContent = searchContent
    }
    
    var body: some View {
        VStack(spacing: 0){
            // MARK: 헤더
            switch searchContent {
            case .event:
                SearchHeader(title: "검색")
            case .vibe:
                SearchHeader(title: "공연 찾기")
            }
            
            // MARK: 검색창
            SearchField(text: $searchText,searchStatus: $eventSearchStatus, isFocused: $searchFieldFocus)
            
            switch eventSearchStatus {
                // MARK: 검색 결과가 나오기 전의 뷰
            case .beforeSearch:
                switch searchContent {
                case .event:
                    SearchBeforeView(text: $searchText, isFocused: $searchFieldFocus)
                        .padding(.horizontal, 16)
                case .vibe:
                    EmptyView()
                }
                
                // MARK: 텍스트 필드에 검색을 하는 중인 뷰
            case .searching:
                SearchingView(selectedEvent: $selectedEvent, searchContent: searchContent)
                
                // MARK: 검색 결과가 나온 후의 뷰
            case .afterSearch:
                SearchAfterView(selectedEvent: $selectedEvent, searchContent: searchContent)
                    .padding(.horizontal, 16)
            }
            Spacer()
        }
        .onChange(of: [searchFieldFocus, searchText.isEmpty]) {
            eventSearchStatus = searchCase()
        }
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
}

#Preview {
    SearchScreen(searchContent: .event)
        .backgroundForKEEV()
}
