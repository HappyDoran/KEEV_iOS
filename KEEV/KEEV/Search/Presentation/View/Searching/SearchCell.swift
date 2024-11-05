//
//  SearchCell.swift
//  KEEV
//
//  Created by Doran on 11/3/24.
//

import SwiftUI

/// 검색을 하는 도중 나오는 키워드 검색 뷰
///
/// - Parameters:
///   - event: 키워드를 토대로 나오는 이벤트 정보
///   - onClick: 셀 클릭시 발생하는 함수
///
/// - Author: Doran
struct SearchCell: View {
    private let event: EventDTO
    private let onClick: () -> Void
    
    init(event: EventDTO, onClick: @escaping ()-> Void){
        self.event = event
        self.onClick = onClick
    }
    
    var body: some View {
        Button(action: onClick ){
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
                            .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                            .foregroundColor(.gray500)
                        Spacer()
                    }
                    .padding(.top, 4)
                    
                    // MARK: 장소
                    Text(event.place)
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                        .foregroundColor(.gray500)
                        .padding(.top, 2)
                }
            }
        }
        .frame(height: 72)
    }
}

#Preview {
    SearchCell(event: EventDTO(id: "1", title: "AAA TOUR BY HYUKOH & SUNSET ROLLERCOASTER", startDate: "2024. 10. 4", endDate: "2024. 10. 6", place: "홍대 일대", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF251812_241021_161408.png"), onClick: {})
        .backgroundForKEEV()
}
