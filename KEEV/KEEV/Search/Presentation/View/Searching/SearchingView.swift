//
//  Searching.swift
//  KEEV
//
//  Created by Doran on 11/5/24.
//

import SwiftUI

struct SearchingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var events: [SimpleEventUIO] = [
        .dummy0,.dummy1
    ]
    
    @Binding private var selectedEvent: SimpleEventUIO?
    var searchContent: SearchContent
    private let onClick: () -> Void
    
    init(selectedEvent: Binding<SimpleEventUIO?> = Binding.constant(nil), searchContent: SearchContent, onClick: @escaping ()-> Void) {
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
                SearchCell(text: event.name)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .onTapGesture {
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
