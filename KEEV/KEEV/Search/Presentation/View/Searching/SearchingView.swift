//
//  Searching.swift
//  KEEV
//
//  Created by Doran on 11/5/24.
//

import SwiftUI

struct SearchingView: View {
    @State private var events: [EventDTO] = [
        EventDTO(id: "1", title: "AAA TOUR BY HYUKOH & SUNSET ROLLERCOASTER", startDate: "2024. 10. 4", endDate: "2024. 10. 4", place: "C5", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF252023_241024_110002.jpg")]
    
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
                    print("EventDetail로 이동")
                }
            }
        }.padding(.top, 12)
    }
}

#Preview {
    SearchingView()
}
