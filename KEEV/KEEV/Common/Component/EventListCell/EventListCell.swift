//
//  EventListCell.swift
//  KEEV
//
//  Created by 김준성 on 11/18/24.
//

import SwiftUI

// - MARK: 셀의 핵심부
/// 간단한 이벤트 정보를 나열하는 스크린 또는 뷰에서 사용하는 셀
///
/// - Author: newJunsung
struct EventListCell: View {
    let event: SimpleEventUIO
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            poster
            content
            Spacer()
        }
        .padding(.vertical, 8)
        .frame(height: 132)
        .frame(maxWidth: .infinity)
    }
}

// - MARK: 셀의 컴포넌트
private extension EventListCell {
    var poster: some View {
        URLCachedImage(url: event.posterURL) { phase in
            if let image = phase.image {
                // Image가 성공적으로 불러졌을 때
                image
                    .resizable()
            } else if phase.error != nil {
                // 에러가 발생했을 때
                Image(systemName: "xmark.circle.fill")
                    .resizable()
            } else {
                // 로딩 중일 때
                ProgressView()
                    .frame(width: 87, height: 116)
            }
        }
        .mask(
            RoundedRectangle(cornerRadius: 6)
                .foregroundStyle(.gray500)
        )
        .frame(width: 87)
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(event.dDay!)")
            name
            durationAndPlace
        }
    }
    
    var name: some View {
        let font = PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .semibold))
        return Text(event.name)
            .multilineTextAlignment(.leading)
            .lineLimit(2)
            .foregroundStyle(.gray100)
            .figmaFont(font)
    }
    
    var durationAndPlace: some View {
        let font = PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium))
        return VStack(alignment: .leading, spacing: 2) {
            Text("\(event.startDate) ~ \(event.endDate)")
            Text(event.placeName)
        }
        .lineLimit(1)
        .foregroundStyle(.gray400)
        .figmaFont(font)
    }
}

#Preview {
    EventListCell(event: .dummy2)
}
