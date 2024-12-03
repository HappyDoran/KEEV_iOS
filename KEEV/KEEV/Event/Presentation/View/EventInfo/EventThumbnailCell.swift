//
//  EventThumbnailCell.swift
//  KEEV
//
//  Created by Doran on 11/1/24.
//

import SwiftUI

/// D-Day가 들어간 공연 썸네일을 나타내기 위한 뷰
///
/// - Parameters:
///   - ConcertDTO: 공연 정보를 담은 모델
///
/// - Author: Doran
struct EventThumbnailCell: View {
    private let event: SimpleEventUIO
    
    init(event: SimpleEventUIO) {
        self.event = event
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            // MARK: 포스터
            URLCachedImage(url: event.posterURL) { phase in
                if let image = phase.image {
                    // Image가 성공적으로 불러졌을 때
                    image
                        .resizable()
                } else if phase.error != nil {
                    // 에러가 발생했을 때
                    Image("PosterError")
                        .resizable()
                } else {
                    // 로딩 중일 때
                    ProgressView()
                        .frame(width: 87, height: 116)
                }
            }
            .mask(
                RoundedRectangle(cornerRadius: 6)
                    .foregroundStyle(.gray500)
            )
            .frame(width: 117, height: 160)
            
            // MARK: D-Day Box
            //이후 모델의 날짜 타입이 Date가 되면 수정될 예정입니다.
            DDayBox(difference: event.dDay).padding(.top, 8)
            
            // MARK: 이벤트 제목
            Text(event.name)
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                .foregroundColor(.gray300)
                .multilineTextAlignment(.leading)
                .frame(width: 115)
                .lineLimit(2)
                .truncationMode(.tail)
                .padding(.top, 8)
                .frame(alignment: .leading)
        }
        .frame(width: 115)
    }
}

#Preview {
    @Previewable let smallThumbnailEvent: EventDTO = EventDTO(id : "1", title: "Fiji Blue LIVE IN SEOUL 'The Glide Tour Asia'", startDate: "2024.12.13", endDate: "2024.12.25", place: "홍대 일대", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF252023_241024_110002.jpg")
    EventThumbnailCell(event: .dummy0)
        .backgroundForKEEV()
}
