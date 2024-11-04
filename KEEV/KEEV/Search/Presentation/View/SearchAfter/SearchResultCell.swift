//
//  SearchResultCell.swift
//  KEEV
//
//  Created by Doran on 11/4/24.
//

import SwiftUI

/// 검색 결과를 보여주는 셀뷰
///
/// - Parameters:
///   - event: 불러온 이벤트
///   - onClick: 해당 이벤트 클릭시 발생하는 함수
///
/// - Author: Doran
struct SearchResultCell: View {
    private let event: ConcertDTO
    private let onClick: () -> Void
    
    init(event: ConcertDTO, onClick: @escaping ()-> Void){
        self.event = event
        self.onClick = onClick
    }
    
    var body: some View {
        Button(action: onClick ){
            HStack(spacing: 16){
                // MARK: 포스터
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray900)
                        .frame(width: 87, height: 116)
                    
                    
                    AsyncImage(url: URL(string: event.poster)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(6)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 87, height: 116)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    DDayBox(date: event.startDate.toDate(format: "yyyy.MM.dd")!)
                    
                    
                    // MARK: 이벤트 제목
                    Text(event.title)
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .semibold)))
                        .foregroundColor(.gray100)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .frame(width: 258, height: 44)
                        .padding(.top, 8)
                    
                    // MARK: 기간
                    HStack(spacing: 0) {
                        Text("\(event.startDate)~\(event.endDate)")
                            .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium))).foregroundColor(.gray400)
                        Spacer()
                    }
                    .padding(.top, 8)
                    
                    // MARK: 장소
                    Text(event.place)
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium))).foregroundColor(.gray400)
                        .padding(.top, 2)
                }
            }
        }
    }
}

#Preview {
    SearchResultCell(event: ConcertDTO(id: "1", title: "AAA TOUR BY HYUKOH & SUNSET ROLLERCOASTER", startDate: "2024. 10. 4", endDate: "2024. 10. 6", place: "홍대 일대", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF251812_241021_161408.png"), onClick: {})
        .backgroundForKEEV()
}

