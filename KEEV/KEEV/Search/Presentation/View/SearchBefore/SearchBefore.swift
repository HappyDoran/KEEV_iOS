//
//  SearchBefore.swift
//  KEEV
//
//  Created by Doran on 11/4/24.
//

import SwiftUI

/// 검색 결과가 나오기 전에 나타나는 뷰
///
/// - Parameters:
///   - text: 검색한 텍스트
///
/// 검색하는 텍스트 필드가 어떤 상태인지에 따른 뷰 관리
/// 최근 검색어가 보관되어 있는 모델에 어떠한 값이 있는지(비어 있는지, 값이 있는지)에 따른 뷰 관리
///
/// - Author: Doran
struct SearchBefore: View {
    @State private var events: [ConcertDTO] = [
        ConcertDTO(id: "1", title: "AAA TOUR BY HYUKOH & SUNSET ROLLERCOASTER", startDate: "2024. 10. 4", endDate: "2024. 10. 4", place: "C5", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF252023_241024_110002.jpg")]
    
    @State private var recentKeywords: [RecentSearch] = [
        RecentSearch(term: "세상에서 제일 재밌는 공연", date: Date())
    ]
    
    @Binding private var text: String
    @Binding private var searchStatus: EventSearchStatus
    
    init(text: Binding<String>, searchStatus: Binding<EventSearchStatus>) {
        self._text = text
        self._searchStatus = searchStatus
    }
    
    var body: some View {
        VStack(spacing: 0){
            search(searchText: text)
        }
    }
}

extension SearchBefore {
    /// 검색 상태에 따른 뷰를 보여주기 위한 뷰빌더
    ///
    /// 텍스트가 입력되지 않은 경우, 최근 검색어 뷰가 보여짐
    /// 텍스트가 입력된 경우, 검색 결과가 보여지게 됨
    ///
    /// - Author: Doran
    @ViewBuilder
    private func search(searchText: String) -> some View {
        if searchText == "" {
            recentSearchHeader
            if recentKeywords.isEmpty {
                nothingFound
            }
            else {
                recentSearch
            }
        }
        else {
            searching
        }
    }
}

extension SearchBefore {
    // MARK: 최근 검색어 헤더
    private var recentSearchHeader: some View {
        HStack(spacing: 0) {
            Text("최근 검색어")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                .foregroundColor(.gray500)
            Spacer()
        }
        .frame(height: 33)
        .padding(.top, 12)
    }
    
    // MARK: 최금 검색어가 없을 경우
    private var nothingFound: some View {
        Text("최근 검색어가 없습니다.")
            .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
            .foregroundColor(.gray700)
            .padding(.top, 205)
    }
    
    // MARK: 최근 검색어 리스트
    private var recentSearch: some View {
        ForEach(recentKeywords, id: \.self.id) { recentSearchItem in
            RecentSearchCell(search: recentSearchItem, onClick: {
                searchStatus = .afterSearch
                print("SearchResult로 이동")
            }) {
                if let index = recentKeywords.firstIndex(where: { $0.id == recentSearchItem.id }) {
                    recentKeywords.remove(at: index)
                }
            }
        }
    }
    
    // MARK: searchText에 텍스트를 입력하는 동안에 나오는 검색 결과
    private var searching: some View {
        ScrollView {
            ForEach(events, id: \.self.id) { event in
                SearchCell(event: event){
                    print("EventDetail로 이동")
                }
            }
        }.padding(.top, 12)
    }
}

#Preview {
    SearchBefore(text: .constant(""), searchStatus: .constant(.beforeSearch))
        .backgroundForKEEV()
}
