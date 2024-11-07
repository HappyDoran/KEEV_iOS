//
//  VibeHeader.swift
//  KEEV
//
//  Created by Doran on 11/6/24.
//

import SwiftUI

struct VibeHeader: View {
    @Environment(\.dismiss) private var dismiss
    
    private let selectedEvent: EventDTO?
    private let rating: Double
    
    init(selectedEvent: EventDTO?, rating: Double) {
        self.selectedEvent = selectedEvent
        self.rating = rating
    }
    
    var body: some View {
        ZStack {
            Text("글쓰기")
                .figmaFont(PretendardFont.title(style: .xs)).foregroundColor(.gray100)
            
            // MARK: 검색 시트 아래로 내리는 버튼
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .semibold)))
                        .foregroundColor(.gray100)
                }
                Spacer()
                
                if selectedEvent != nil {
                    Button(action: {
                        
                    }){
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.brand500)
                                .frame(width: 58, height: 32)
                                .opacity(rating == 0 ? 0.2 : 1)
                            
                            Text("완료")
                                .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium)))
                                .foregroundColor(rating == 0 ? .gray700 : .brand50)
                        }
                    }
                    .disabled(rating == 0)
                }
                
            }
            .frame(height: 48)
        }
    }
}

#Preview {
    VibeHeader(selectedEvent: EventDTO(id: "1", title: "AAA TOUR BY HYUKOH & SUNSET ROLLERCOASTER", startDate: "2024. 10. 4", endDate: "2024. 10. 6", place: "홍대 일대", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF251812_241021_161408.png"), rating: 0.0)
        .backgroundForKEEV()
}

