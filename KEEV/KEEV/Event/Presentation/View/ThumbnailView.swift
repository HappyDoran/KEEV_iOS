//
//  ThumbnailCellView.swift
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
struct ThumbnailCellView: View {
    private let smallThumbnailEvent: ConcertDTO
    
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
    
    init(smallThumbnailEvent: ConcertDTO) {
        self.smallThumbnailEvent = smallThumbnailEvent
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            // MARK: 포스터
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray900)
                    .frame(width: 117, height: 160)
                
                AsyncImage(url: URL(string: smallThumbnailEvent.poster)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 115, height: 158)
                
                
            }
            // MARK: D-Day Box
            //이후 모델의 날짜 타입이 Date가 되면 dateFormatter는 없어집니다.
            DDayBox(date: dateFormatter.date(from: smallThumbnailEvent.startDate)!).padding(.top, 8)
            
            // MARK: 이벤트 제목
            Text(smallThumbnailEvent.title)
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                .foregroundColor(.gray300)
                .multilineTextAlignment(.leading)
                .frame(width: 115)
                .lineLimit(2)
                .truncationMode(.tail)
                .padding(.top, 8)
        }
        .frame(width: 115)
    }
}

#Preview {
    @Previewable let smallThumbnailEvent: ConcertDTO = ConcertDTO(id : "1", title: "Fiji Blue LIVE IN SEOUL 'The Glide Tour Asia'", startDate: "2024.12.13", endDate: "2024.12.25", place: "홍대 일대", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF252023_241024_110002.jpg")
    ThumbnailCellView(smallThumbnailEvent: smallThumbnailEvent)
        .backgroundForKEEV()
}
