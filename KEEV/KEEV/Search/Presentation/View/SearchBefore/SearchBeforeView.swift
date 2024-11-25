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
struct SearchBeforeView: View {
    @State private var recentKeywords: [RecentSearch] = [
        RecentSearch(term: "세상에서 제일 재밌는 공연", date: Date())
    ]
    
    @Binding private var text: String
    private var isFocused: FocusState<Bool>.Binding
    
    init(text: Binding<String>, isFocused: FocusState<Bool>.Binding) {
        self._text = text
        self.isFocused = isFocused
    }
    
    var body: some View {
        VStack(spacing: 0){
            search
        }
    }
}

extension SearchBeforeView {
    /// 최근 검색 배열의 유무에 따른 뷰를 보여주기 위한 뷰빌더
    ///
    /// 최근 검색어가 없는 경우, 없는 결과가 보여지게 됨
    /// 최근 검색어가 있는 경우, 최근 검색 결과가 보여지게 됨
    ///
    /// - Author: Doran
    @ViewBuilder
    private var search: some View {
        recentSearchHeader
        if recentKeywords.isEmpty {
            nothingFound
        }
        else {
            recentSearch
        }
    }
}

extension SearchBeforeView {
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
        Text("최근 검색어가 없습니다")
            .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
            .foregroundColor(.gray700)
            .padding(.top, 205)
    }
    
    // MARK: 최근 검색어 리스트
    private var recentSearch: some View {
        ForEach(recentKeywords) { recentSearchItem in
            RecentSearchCell(search: recentSearchItem, onClick: {
                text = recentSearchItem.term
                isFocused.wrappedValue = false
                print("SearchResult로 이동")
            }) {
                if let index = recentKeywords.firstIndex(where: { $0.id == recentSearchItem.id }) {
                    recentKeywords.remove(at: index)
                }
            }
        }
    }
}

#Preview {
    SearchBeforeView(text: .constant(""),isFocused:  FocusState<Bool>().projectedValue)
        .backgroundForKEEV()
}
