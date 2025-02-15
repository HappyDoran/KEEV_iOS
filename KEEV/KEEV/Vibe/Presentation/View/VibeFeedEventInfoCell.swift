//
//  VibeFeedEventInfoCell.swift
//  KEEV
//
//  Created by Doran on 2/15/25.
//

import SwiftUI

/// 피드와, 피드를 통한 바이브 상세 스크린 접근 시 사용하는 이벤트 정보 셀
///
/// - Author: Doran
struct VibeFeedEventInfoCell: View {
    private let eventData: SimpleEventUIO
    
    init(eventData: SimpleEventUIO) {
        self.eventData = eventData
    }
    
    var body: some View {
        HStack(spacing: 12) {
            URLCachedImage(
                url: eventData.posterURL
            ) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else if phase.error == nil {
                    ProgressView()
                } else {
                    Text(phase.error?.localizedDescription ?? "알 수 없는 에러가 발생했습니다.")
                }
            }
            .frame(width: 48, height: 64, alignment: .center)
            .mask(RoundedRectangle(cornerRadius: 4))
            
            VStack(alignment: .leading, spacing: 0) {
                Text(eventData.name)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .semibold)))
                    .foregroundStyle(.gray50)
                    .lineLimit(1)
                    .padding(.bottom, 4)
                
                Text("\(eventData.startDate) ~ \(eventData.endDate)")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                    .foregroundStyle(.gray300)
                    .lineLimit(1)
                    .padding(.bottom, 2)
                
                Text(eventData.placeName)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                    .foregroundStyle(.gray300)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    VibeFeedEventInfoCell(eventData: .dummy0)
}
