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
    private let onClick: (() -> Void)?
    
    init(event: SimpleEventUIO, onClick: (()-> Void)?){
        self.event = event
        self.onClick = onClick
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16){
            // MARK: 포스터
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
            .frame(width: 60, height: 82, alignment: .center)
            .mask(RoundedRectangle(cornerRadius: 6))
            
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
                        .lineLimit(1)
                        .foregroundColor(.gray400)
                        .padding(.top, 2)
                    Spacer()
                    if let onClick {
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
}

#Preview {
    VibeEventCell(event: .dummy5, onClick: {}).backgroundForKEEV()
}
