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
    private let event: SimpleEventUIO
    private let onClick: () -> Void
    
    init(event: SimpleEventUIO, onClick: @escaping ()-> Void){
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
                    
                    URLCachedImage(
                        url: event.posterURL
                    ) { phase in
                        if let image = phase.image { // 이미지를 성공적으로 불러왔을 때
                            image
                                .resizable()
                                .cornerRadius(6)
                        } else if phase.error == nil { // 이미지를 불러오는 중일 때
                            ProgressView()
                        } else { // 에러가 발생했을 때
                            Text(phase.error?.localizedDescription ?? "알 수 없는 에러가 발생했습니다.")
                        }
                    }
                    .frame(width: 87, height: 116, alignment: .center)
                }

                VStack(alignment: .leading, spacing: 0) {
                    DDayBox(date: event.startDate.toDate(format: "yyyy.MM.dd")!)
                    
                    
                    // MARK: 이벤트 제목
                    Text(event.name)
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .semibold)))
                        .foregroundColor(.gray100)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .frame(height: 44)
                        .padding(.top, 8)
                    
                    // MARK: 기간
                    HStack(spacing: 0) {
                        Text("\(event.startDate)~\(event.endDate)")
                            .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                            .foregroundColor(.gray400)
                        Spacer()
                    }
                    .padding(.top, 8)
                    
                    // MARK: 장소
                    Text(event.placeName)
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                        .foregroundColor(.gray400)
                        .padding(.top, 2)
                }
            }
        }
    }
}

#Preview {
    SearchResultCell(event: .dummy0, onClick: {})
        .backgroundForKEEV()
}

