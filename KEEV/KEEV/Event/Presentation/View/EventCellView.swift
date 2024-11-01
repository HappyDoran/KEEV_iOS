//
//  EventCellView.swift
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
struct EventCellView: View {
    private let eventCellEvent: ConcertDTO
    @State var image:UIImage = UIImage()
    
    init(eventCellEvent: ConcertDTO) {
        self.eventCellEvent = eventCellEvent
    }
    
    var body: some View {
        HStack(spacing: 8){
            // MARK: 포스터
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray900)
                    .frame(width: 64, height:90)
                
                AsyncImage(url: URL(string: eventCellEvent.poster)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 62)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                // MARK: 이벤트 제목
                Text(eventCellEvent.title)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .semibold)))
                    .foregroundColor(.gray100)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .frame(height: 44)
                
                // MARK: 기간
                HStack(spacing: 0) {
                    Text(eventCellEvent.startDate).figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium))).foregroundColor(.gray400)
                    Text("~").figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium))).foregroundColor(.gray400)
                    Text(eventCellEvent.endDate).figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium))).foregroundColor(.gray400)
                    Spacer()
                }.padding(.top, 8)
                
                // MARK: 장소
                Text(eventCellEvent.place).figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium))).foregroundColor(.gray400).padding(.top, 2)
            }
            .frame(width: 241, height: 88)
        }
    }
}

#Preview {
    @Previewable let eventCellEvent: ConcertDTO =
    ConcertDTO(id: "1", title: "AAA TOUR BY HYUKOH & \nSUNSET ROLLERCOASTER", startDate: "2024. 10. 4", endDate: "2024. 10. 6", place: "올림픽공원 올림픽홀", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF251812_241021_161408.png")
    
    
    EventCellView(eventCellEvent: eventCellEvent)
        .backgroundForKEEV()
}
