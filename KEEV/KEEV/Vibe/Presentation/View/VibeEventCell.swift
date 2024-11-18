//
//  VibeEventCell.swift
//  KEEV
//
//  Created by Doran on 11/6/24.
//

import SwiftUI

/// 선택한 이벤트가 표시되는 셀
///
/// - Parameters:
///   - event: 선택한 이벤트
///   - onClick: 변경 텍스트 클릭시 발생하는 함수
///
/// - Author: Doran
struct VibeEventCell: View {
    private let event: SimpleEventUIO
    private let onClick: () -> Void
    
    init(event: SimpleEventUIO, onClick: @escaping ()-> Void){
        self.event = event
        self.onClick = onClick
    }
    
    var body: some View {
        HStack(spacing: 16){
            // MARK: 포스터
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray900)
                    .frame(width: 60, height: 82)
                
                URLCachedImage(
                    url: event.posterURL
                ) { phase in
                    if let image = phase.image { // 이미지를 성공적으로 불러왔을 때
                        image
                            .resizable()
//                                .aspectRatio(contentMode: .fit)
                            .cornerRadius(6)
                    } else if phase.error == nil { // 이미지를 불러오는 중일 때
                        ProgressView()
                    } else { // 에러가 발생했을 때
                        Text(phase.error?.localizedDescription ?? "알 수 없는 에러가 발생했습니다.")
                    }
                }
                .frame(width: 60, height: 82, alignment: .center)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                
                // MARK: 이벤트 제목
                Text(event.name)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .semibold)))
                    .foregroundColor(.gray100)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .truncationMode(.tail)
                
                // MARK: 기간
                HStack(spacing: 0) {
                    Text("\(event.startDate)~\(event.endDate)")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                        .foregroundColor(.gray400)
                    Spacer()
                }
                .padding(.top, 4)
                
                HStack(spacing: 0) {
                    // MARK: 장소
                    Text(event.placeName)
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                        .foregroundColor(.gray400)
                        .padding(.top, 2)
                    Spacer()
                    Button(action: onClick ){
                        Text("변경")
                            .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                            .foregroundColor(.gray500)
                            .overlay(
                                Rectangle()
                                    .fill(.gray500)
                                    .frame(width: 23, height: 1)
                                , alignment: .bottom
                            )
                    }
                }
            }
        }
    }
}

#Preview {
    VibeEventCell(event: .dummy0, onClick: {}).backgroundForKEEV()
}
