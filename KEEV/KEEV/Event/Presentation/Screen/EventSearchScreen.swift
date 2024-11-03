//
//  EventSearchScreen.swift
//  KEEV
//
//  Created by Doran on 11/2/24.
//

import SwiftUI

struct EventSearchScreen: View {
    @StateObject private var eventService = EventService()
    @State private var searchText: String = ""
    
    @State private var events: [ConcertDTO] = [
        ConcertDTO(id: "1", title: "example1", startDate: "2024. 10. 4", endDate: "2024. 10. 4", place: "C5", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF252023_241024_110002.jpg"),
        ConcertDTO(id: "2", title: "example2", startDate: "2024. 10. 4", endDate: "2024. 10. 4", place: "C5", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF251812_241021_161408.png"),
        ConcertDTO(id: "3", title: "example3", startDate: "2024. 10. 4", endDate: "2024. 10. 4", place: "C5", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF252023_241024_110002.jpg"),
        ConcertDTO(id: "4", title: "example4", startDate: "2024. 10. 4", endDate: "2024. 10. 4", place: "C5", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF252023_241024_110002.jpg")
    ]
    
    @State private var recentSearch: [RecentSearch] = [
        RecentSearch(term: "세상에서 제일 재밌는 공연", date: Date()),
        RecentSearch(term: "카모 콘서트", date: Date()),
        RecentSearch(term: "김준성 30주년 팬미팅", date: Date()),
        RecentSearch(term: "부산 콘서트", date: Date())
    ]
    
    @Binding private var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    var body: some View {
        VStack(spacing: 0){
            SearchHeader(isPresented: $isPresented)
            SearchField(text: $searchText)
            searchResults(searchText: searchText).padding(.horizontal, 16)
            Spacer()
        }
        .backgroundForKEEV()
    }
}

extension EventSearchScreen {
    @ViewBuilder
    private func searchResults(searchText: String) -> some View {
        if searchText == "" {
            HStack(spacing: 0) {
                Text("최근 검색어")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                    .foregroundColor(.gray500)
                Spacer()
            }
            .frame(height: 33)
            .padding(.top, 12)
            
            if recentSearch.isEmpty {
                Text("최근 검색어가 없습니다.")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                    .foregroundColor(.gray700)
                    .padding(.top, 205)
            }
            else {
                ForEach(recentSearch, id: \.self.id) { recentSearchItem in
                    RecentSearchCell(search: recentSearchItem)
                }
            }
        }
        else {
            ScrollView {
                ForEach(events, id: \.self.id) { event in
                    SearchCell(event: event)
                }
            }.padding(.top, 12)
        }
    }
}

extension EventSearchScreen {
}


#Preview {
    EventSearchScreen(isPresented: .constant(false))
        .backgroundForKEEV()
}
