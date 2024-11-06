//
//  VibeEventCell.swift
//  KEEV
//
//  Created by Doran on 11/6/24.
//

import SwiftUI

struct VibeEventCell: View {
    private let event: EventDTO
    private let onClick: () -> Void
    
    init(event: EventDTO, onClick: @escaping ()-> Void){
        self.event = event
        self.onClick = onClick
    }
    
    var body: some View {
        HStack(spacing: 16){
            // MARK: 포스터
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray900)
                    .frame(width: 60, height: 82)
                
                
                AsyncImage(url: URL(string: event.poster)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(6)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 60, height: 82)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                
                // MARK: 이벤트 제목
                Text(event.title)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .semibold)))
                    .foregroundColor(.gray100)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .truncationMode(.tail)
                
                // MARK: 기간
                HStack(spacing: 0) {
                    Text("\(event.startDate)~\(event.endDate)")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                        .foregroundColor(.gray400)
                    Spacer()
                }
                .padding(.top, 4)
                
                HStack(spacing: 0) {
                    // MARK: 장소
                    Text(event.place)
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                        .foregroundColor(.gray400)
                        .padding(.top, 2)
                    Spacer()
                    Button(action: onClick ){
                        Text("변경")
                            .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                            .foregroundColor(.gray500)
                            .overlay(
                                Rectangle()
                                    .fill(.gray500)
                                    .frame(width: 23, height: 1)
                                , alignment: .bottom
                            )
                    }
                }
            }
        }
    }
}

#Preview {
    VibeEventCell(event: EventDTO(id: "1", title: "AAA TOUR BY HYUKOH & SUNSET ROLLERCOASTER", startDate: "2024. 10. 4", endDate: "2024. 10. 6", place: "홍대 일대", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF251812_241021_161408.png"), onClick: {}).backgroundForKEEV()
}
