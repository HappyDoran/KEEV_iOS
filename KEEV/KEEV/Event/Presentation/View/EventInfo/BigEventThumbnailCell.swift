//
//  BigEventThumbnailCell.swift
//  KEEV
//
//  Created by Doran on 11/1/24.
//

import SwiftUI

/// 횡스크롤에 들어갈 공연 썸네일을 나타내기 위한 뷰
///
/// - Parameters:
///   - ConcertDTO: 공연 정보를 담은 모델
///
/// - Author: Doran
struct BigEventThumbnailCell: View {
    private let event: SimpleEventUIO
    
    init(event: SimpleEventUIO) {
        self.event = event
    }
    
    var body: some View {
        VStack(spacing: 6) {
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
            .frame(width: 117, height: 160)
            .frame(width: 116, height: 160)
            
            // MARK: 이벤트 제목
            Text(event.name)
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                .foregroundColor(.gray300)
                .multilineTextAlignment(.leading)
                .frame(width: 116, alignment: .leading)
                .lineLimit(1)
                .truncationMode(.tail)
            
        }
    }
}

#Preview {
    @Previewable let bigThumbnailEvent: EventDTO = EventDTO(id: "1", title: "Fiji Blue LIVE IN SEOUL 'The Glide Tour Asia'", startDate: "2024. 10. 4", endDate: "2024. 10. 6", place: "올림픽공원 올림픽홀", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF251881_241022_122743.jpg")
    BigEventThumbnailCell(event: .dummy0)
        .backgroundForKEEV()
}
