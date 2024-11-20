//
//  EventDetailThumbnail.swift
//  KEEV
//
//  Created by Doran on 11/17/24.
//

import SwiftUI

/// 이벤트 이미지를 표시하는 썸네일 뷰
///
/// - Parameter selectedEvent: 썸네일로 표시할 이벤트 객체
///
/// - Author: Doran
struct EventDetailThumbnail: View {
    private let selectedEvent: DetailEventUIO
    
    init(selectedEvent: DetailEventUIO) {
        self.selectedEvent = selectedEvent
    }
    
    var body: some View {
        URLCachedImage(
            url: selectedEvent.posterURL
        ) { phase in
            if let image = phase.image { // 이미지를 성공적으로 불러왔을 때
                image
                    .resizable()
                    .scaledToFill()
            } else if phase.error == nil { // 이미지를 불러오는 중일 때
                ProgressView()
            } else { // 에러가 발생했을 때
                Text(phase.error?.localizedDescription ?? "알 수 없는 에러가 발생했습니다.")
            }
        }
    }
}

#Preview {
    EventDetailThumbnail(selectedEvent: .dummy0)
}
