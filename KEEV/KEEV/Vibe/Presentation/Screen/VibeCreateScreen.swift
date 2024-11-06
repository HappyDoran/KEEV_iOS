//
//  VibeCreateScreen.swift
//  KEEV
//
//  Created by Doran on 11/5/24.
//

import SwiftUI

struct VibeCreateScreen: View {
    @State private var isPresented = false
    @State private var selectedEvent: EventDTO? = EventDTO(id: "1", title: "AAA TOUR BY HYUKOH & SUNSET ROLLERCOASTER", startDate: "2024. 10. 4", endDate: "2024. 10. 6", place: "홍대 일대", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF251812_241021_161408.png")
//    @State private var selectedEvent: EventDTO? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            VibeHeader()
            
            if let event = selectedEvent {
                VibeEventCell(event: event){
                    isPresented.toggle()
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
                
                VibeRatingCell()
                    .padding(.top, 36)
                Rectangle().fill(Color.gray800).frame(height: 1)
            }
            else {
                EventSelectCell(isPresented: $isPresented)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                
            }
            
            Spacer()
        }
        .fullScreenCover(isPresented: $isPresented) {
            SearchScreen(selectedEvent: $selectedEvent, searchContent: .vibe)
        }
        .backgroundForKEEV()
    }
}

#Preview {
    VibeCreateScreen()
}
