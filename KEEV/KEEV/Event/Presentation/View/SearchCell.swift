//
//  SearchCell.swift
//  KEEV
//
//  Created by Doran on 11/3/24.
//

import SwiftUI

struct SearchCell: View {
    private let event: ConcertDTO
    
    init(event: ConcertDTO) {
        self.event = event
    }
    
    var body: some View {
        HStack(spacing: 12){
            // MARK: 포스터
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray900)
                    .frame(width: 48, height: 64)
                
                
                AsyncImage(url: URL(string: event.poster)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(6)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 48, height: 64)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                // MARK: 이벤트 제목
                Text(event.title)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .semibold)))
                    .foregroundColor(.gray100)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(height: 21)
                
                // MARK: 기간
                HStack(spacing: 0) {
                    Text("\(event.startDate)~\(event.endDate)")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium))).foregroundColor(.gray500)
                    Spacer()
                }
                .padding(.top, 4)
                
                // MARK: 장소
                Text(event.place)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium))).foregroundColor(.gray500)
                    .padding(.top, 2)
            }
        }
        .frame(width: 353, height: 72)
    }
}

#Preview {
    SearchCell(event: ConcertDTO(id: "1", title: "AAA TOUR BY HYUKOH & SUNSET ROLLERCOASTER", startDate: "2024. 10. 4", endDate: "2024. 10. 6", place: "홍대 일대", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF251812_241021_161408.png"))
        .backgroundForKEEV()
}
