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
    @State private var events: [EventDTO] = [
        EventDTO(id: "1", title: "AAA TOUR BY HYUKOH & SUNSET ROLLERCOASTER", startDate: "2024. 10. 4", endDate: "2024. 10. 6", place: "홍대 일대", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF251812_241021_161408.png")]
    
    @Binding private var selectedEvent: EventDTO?
    var searchContent: SearchContent
    
    init(selectedEvent: Binding<EventDTO?> = Binding.constant(nil), searchContent: SearchContent) {
        self._selectedEvent = selectedEvent
        self.searchContent = searchContent
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
                    switch searchContent{
                    case .event:
                        print("EventDetail 이동")
                    case .vibe:
                        selectedEvent = event
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SearchAfterView(searchContent: .event).backgroundForKEEV()
}
