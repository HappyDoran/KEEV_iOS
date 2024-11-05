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
struct EventSearchScreen: View {
    @State private var searchText: String = ""
    @State private var eventSearchStatus: EventSearchStatus = .beforeSearch
    
    @FocusState private var searchFieldFocus: Bool
    
    @Binding private var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    var body: some View {
        VStack(spacing: 0){
            // MARK: 헤더
            SearchHeader(isPresented: $isPresented)
            
            // MARK: 검색창
            SearchField(text: $searchText,searchStatus: $eventSearchStatus, isFocused: $searchFieldFocus)
            
            switch eventSearchStatus {
                // MARK: 검색 결과가 나오기 전의 뷰
            case .beforeSearch:
                SearchBeforeView(text: $searchText, isFocused: $searchFieldFocus)
                    .padding(.horizontal, 16)
                
                // MARK: 텍스트 필드에 검색을 하는 중인 뷰
            case .searching:
                SearchingView()
                
                // MARK: 검색 결과가 나온 후의 뷰
            case .afterSearch:
                SearchAfterView()
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

extension EventSearchScreen {
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
    EventSearchScreen(isPresented: .constant(false))
        .backgroundForKEEV()
}
