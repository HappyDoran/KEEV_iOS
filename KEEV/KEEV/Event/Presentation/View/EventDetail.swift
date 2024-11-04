//
//  EventDetail.swift
//  KEEV
//
//  Created by Doran on 11/4/24.
//

import SwiftUI

struct EventDetail: View {
    let event: ConcertDTO
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    EventDetail(event: ConcertDTO(id: "1", title: "AAA TOUR BY HYUKOH & SUNSET ROLLERCOASTER", startDate: "2024. 10. 4", endDate: "2024. 10. 6", place: "홍대 일대", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF251812_241021_161408.png"))
}
