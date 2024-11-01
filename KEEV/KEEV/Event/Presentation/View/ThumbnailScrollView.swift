//
//  ThumbnailScrollCellView.swift
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
struct ThumbnailScrollCellView: View {
    private let bigThumbnailEvent: ConcertDTO
    
    init(bigThumbnailEvent: ConcertDTO) {
        self.bigThumbnailEvent = bigThumbnailEvent
    }
    
    var body: some View {
        VStack(spacing: 6) {
            // MARK: 포스터
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray900)
                    .frame(width: 116, height: 160)
                
                AsyncImage(url: URL(string: bigThumbnailEvent.poster)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(4)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 116, height: 160)
            }
            
            // MARK: 이벤트 제목
            Text(bigThumbnailEvent.title)
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                .foregroundColor(.gray300)
                .multilineTextAlignment(.leading)
                .frame(width: 116)
                .lineLimit(1)
                .truncationMode(.tail)
            
        }
    }
}

#Preview {
    @Previewable let bigThumbnailEvent: ConcertDTO = ConcertDTO(id: "1", title: "Fiji Blue LIVE IN SEOUL 'The Glide Tour Asia'", startDate: "2024. 10. 4", endDate: "2024. 10. 6", place: "올림픽공원 올림픽홀", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF251881_241022_122743.jpg")
    ThumbnailScrollCellView(bigThumbnailEvent: bigThumbnailEvent)
        .backgroundForKEEV()
}
