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
    @State private var events: [ConcertDTO] = []
    @State private var error: String? = nil
    @State private var isLoading: Bool = false
    @State private var keyword: String = ""
    @State private var recentSearch: [RecentSearch] = [
        RecentSearch(term: "세상에서 제일 재밌는 공연", date: Date()),
        RecentSearch(term: "카모 콘서트", date: Date()),
        RecentSearch(term: "김준성 30주년 팬미팅", date: Date()),
        RecentSearch(term: "부산 콘서트", date: Date())]
    
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
        .onChange(of: searchText) { _, newValue in
            loadEventDataByKeyword(keyword: newValue)
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
                ForEach(events, id: \.id) { event in
                    SearchCell(event: event)
                }
            }
        }
    }
}

extension EventSearchScreen {
    private func loadEventDataByKeyword(keyword: String) {
        isLoading = true
        Task.detached {
            do {
                let loadedEvents = try await eventService.loadEventByKeyword(
                    startDate: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 4)) ?? Date(),
                    endDate: Date(),
                    keyword: keyword,
                    page: 1,
                    rows: 5
                )
                await MainActor.run {
                    self.events = loadedEvents
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}


#Preview {
    EventSearchScreen(isPresented: .constant(false))
        .backgroundForKEEV()
}
