//
//  EventCell.swift
//  KEEV
//
//  Created by Doran on 11/1/24.
//

import SwiftUI

/// 공연 셀을 나타내기 위한 뷰
///
/// - Parameters:
///   - ConcertDTO: 공연 정보를 담은 모델
///
/// - Author: Doran
struct EventCell: View {
    private let event: SimpleEventUIO
    
    init(event: SimpleEventUIO) {
        self.event = event
    }
    
    var body: some View {
        HStack(spacing: 8){
            // MARK: 포스터
            AsyncImage(url: event.posterURL) { image in
                image
                    .resizable()
            } placeholder: {
                ProgressView()
            }
            .mask {
                RoundedRectangle(cornerRadius: 8)
            }
            .frame(width: 62, height: 90)
            
            VStack(alignment: .leading, spacing: 0) {
                // MARK: 이벤트 제목
                Text(event.name)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .semibold)))
                    .foregroundColor(.gray100)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .frame(height: 44)
                
                // MARK: 기간
                HStack(spacing: 0) {
                    Text("\(event.startDate)~\(event.endDate)")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                        .foregroundColor(.gray400)
                    Spacer()
                }.padding(.top, 8)
                
                // MARK: 장소
                Text(event.placeName)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                    .foregroundColor(.gray400).padding(.top, 2)
                    .frame(alignment: .leading)
            }
            .frame(width: 241, height: 88)
        }
    }
}

#Preview {
    @Previewable let eventCellEvent: EventDTO =
    EventDTO(id: "1", title: "AAA TOUR BY HYUKOH & \nSUNSET ROLLERCOASTER", startDate: "2024. 10. 4", endDate: "2024. 10. 6", place: "올림픽공원 올림픽홀", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF251812_241021_161408.png")
    
    
    EventCell(event: .dummy0)
        .backgroundForKEEV()
}
