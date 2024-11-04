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
    
    @Binding private var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    var body: some View {
        VStack(spacing: 0){
            // MARK: 헤더
            SearchHeader(isPresented: $isPresented)
            
            // MARK: 검색창
            SearchField(text: $searchText,searchStatus: $eventSearchStatus)
            switch eventSearchStatus {
            case .beforeSearch:
                
                // MARK: 검색 결과가 나오기 전의 뷰
                SearchBefore(text: $searchText).padding(.horizontal, 16)
            case .afterSearch:
                
                // MARK: 검색 결과가 나온 후의 뷰
                SearchAfter().padding(.horizontal, 16)
            }
            
            Spacer()
        }
        .backgroundForKEEV()
    }
}


#Preview {
    EventSearchScreen(isPresented: .constant(false))
        .backgroundForKEEV()
}
