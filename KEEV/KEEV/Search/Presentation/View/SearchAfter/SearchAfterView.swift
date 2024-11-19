//
//  SearchAfter.swift
//  KEEV
//
//  Created by Doran on 11/4/24.
//

import SwiftUI

/// 검색 결과가 나온 후의 뷰
///
///  textField에서 return 버튼을 클릭한 후에 textfield에 해당하는 검색 결과가 나옵니다.
///
/// - Author: Doran
struct SearchAfterView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var events: [SimpleEventUIO] = [
        .dummy0
    ]
    
    @Binding private var selectedEvent: SimpleEventUIO?
    private var searchContent: SearchContent
    private let onClick: () -> Void
    
    init(selectedEvent: Binding<SimpleEventUIO?> = Binding.constant(nil), searchContent: SearchContent, onClick: @escaping ()-> Void) {
        self._selectedEvent = selectedEvent
        self.searchContent = searchContent
        self.onClick = onClick
    }
    
    var body: some View {
        VStack(spacing: 0){
            recentSearchHeader
            searchResult
        }
    }
}

extension SearchAfterView {
    // MARK: 헤더 뷰
    private var recentSearchHeader: some View {
        HStack(spacing: 0) {
            Group {
                HStack(spacing: 0){
                    Text("\(events.count)")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                        .foregroundColor(.gray100)
                    Text(" 건의 검색 결과")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                        .foregroundColor(.gray500)
                }
            }
            Spacer()
        }
        .frame(height: 33)
        .padding(.top, 12)
    }
    // MARK: 검색 결과 뷰
    private var searchResult: some View {
        ScrollView {
            ForEach(events) { event in
                SearchResultCell(event: event){
                    selectedEvent = event
                    dismiss()
                    onClick()
                }
            }
        }
    }
}

#Preview {
    SearchAfterView(searchContent: .event, onClick: {}).backgroundForKEEV()
}
