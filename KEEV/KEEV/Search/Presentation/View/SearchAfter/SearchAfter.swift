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
struct SearchAfter: View {
    @State private var events: [ConcertDTO] = [
        ConcertDTO(id: "1", title: "AAA TOUR BY HYUKOH & SUNSET ROLLERCOASTER", startDate: "2024. 10. 4", endDate: "2024. 10. 6", place: "홍대 일대", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF251812_241021_161408.png")]
    
    var body: some View {
        VStack(spacing: 0){
            recentSearchHeader
            searchResult
        }
    }
}

extension SearchAfter {
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
            ForEach(events, id: \.self.id) { event in
                SearchResultCell(event: event){
                    print("EventDetail로 이동")
                }
            }
        }
    }
}

#Preview {
    SearchAfter().backgroundForKEEV()
}
