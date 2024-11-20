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
    private let event: SimpleEventUIO
    private let onClick: () -> Void
    
    init(event: SimpleEventUIO, onClick: @escaping ()-> Void){
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
                    
                    URLCachedImage(url: event.posterURL) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else if phase.error == nil {
                            ProgressView()
                        } else {
                            let _ = print(phase.error!)
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    .frame(width: 48, height: 64, alignment: .center)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    // MARK: 이벤트 제목
                    Text(event.name)
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
                    Text(event.placeName)
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
    SearchCell(event: .dummy0, onClick: {})
        .backgroundForKEEV()
}
