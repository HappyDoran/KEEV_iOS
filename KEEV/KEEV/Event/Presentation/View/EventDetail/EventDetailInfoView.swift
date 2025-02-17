//
//  EventDetailInfoView.swift
//  KEEV
//
//  Created by Doran on 11/17/24.
//

import SwiftUI

/// 이벤트 상세 정보 중에서 텍스트를 표시하는 뷰
///
/// - Parameter selectedEvent: 상세 정보를 표시할 이벤트 객체
///
/// - Author: Doran
struct EventDetailInfoView: LoginCheckableView {
    private let selectedEvent: DetailEventUIO
    
    @Environment(AppState.self) var appState
    
    @Binding private var isFavorite: Bool
    @Binding private var likeCount: Int
    
    init(selectedEvent: DetailEventUIO, isFavorite: Binding<Bool>, likeCount: Binding<Int>) {
        self.selectedEvent = selectedEvent
        self._isFavorite = isFavorite
        self._likeCount = likeCount
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 0){
                titleCell.padding(.top, 24)
                infoCell(title: "날짜", content: "\(selectedEvent.startDate) ~ \(selectedEvent.endDate)")
                    .padding(.top, 12)
                infoCell(title: "장소", content: "\(selectedEvent.placesName)")
                    .padding(.top, 4)
                if let reservationDate = selectedEvent.reservationStartDate {
                    infoCell(title: "예매", content: "\(reservationDate)")
                        .padding(.top, 4)
                }
            }
            .padding(.bottom, 48)
        }
    }
}

extension EventDetailInfoView {
    
    /// 이벤트 제목과 좋아요 버튼을 표시하는 셀뷰
    ///
    /// - Author: Doran
    private var titleCell: some View {
        HStack(alignment: .top, spacing: 20){
            Text("\(selectedEvent.name)")
                .figmaFont(PretendardFont.title(style: .sm))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 0){
                VStack(spacing: 0){
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 21, height: 19)
                        .foregroundStyle(.brand500)
                        .onTapGesture {
                            checkLoginBefore {
                                isFavorite.toggle()
                                likeCount += isFavorite ? 1 : -1
                            }
                        }
                }
                .frame(width: 32, height: 32)
                
                Text("\(likeCount)")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                    .foregroundColor(.gray500)
            }
            .frame(width: 32, height: 49)
        }
    }
}

extension EventDetailInfoView {
    /// 날짜, 장소, 예매일을 표시하는 셀
    ///
    /// - Author: Doran
    private func infoCell(title: String, content: String) -> some View {
        HStack(spacing: 12) {
            VStack(spacing: 0){
                VStack(spacing: 0){
                    Spacer()
                    Text(title)
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .semibold)))
                        .foregroundColor(.gray600)
                }
                .frame(width: 21, height: 15)
                Spacer()
            }
            Text(content)
                .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                .foregroundColor(.gray300)
            Spacer()
        }
    }
}

#Preview {
    EventDetailInfoView(selectedEvent: .dummy0, isFavorite: .constant(false), likeCount: .constant(0))
}
