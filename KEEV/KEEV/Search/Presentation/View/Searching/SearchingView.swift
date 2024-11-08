//
//  Searching.swift
//  KEEV
//
//  Created by Doran on 11/5/24.
//

import SwiftUI

struct SearchingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var events: [EventDTO] = [
        EventDTO(id: "1", title: "AAA TOUR BY HYUKOH & SUNSET ROLLERCOASTER", startDate: "2024. 10. 4", endDate: "2024. 10. 4", place: "C5", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF252023_241024_110002.jpg")]
    
    @Binding private var selectedEvent: EventDTO?
    var searchContent: SearchContent
    private let onClick: () -> Void
    
    init(selectedEvent: Binding<EventDTO?> = Binding.constant(nil), searchContent: SearchContent,onClick: @escaping ()-> Void) {
        self._selectedEvent = selectedEvent
        self.searchContent = searchContent
        self.onClick = onClick
    }
    
    var body: some View {
        VStack(spacing: 0) {
            searching
        }
    }
}

extension SearchingView {
    // MARK: searchText에 텍스트를 입력하는 동안에 나오는 검색 결과
    private var searching: some View {
        ScrollView {
            ForEach(events) { event in
                SearchCell(event: event){
                    selectedEvent = event
                    dismiss()
                    onClick()
                }
            }
        }.padding(.top, 12)
    }
}

#Preview {
    SearchingView(searchContent: .event, onClick: {})
        .backgroundForKEEV()
}
