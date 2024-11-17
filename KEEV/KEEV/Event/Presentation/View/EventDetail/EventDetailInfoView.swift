//
//  EventDetailInfoView.swift
//  KEEV
//
//  Created by Doran on 11/17/24.
//

import SwiftUI

struct EventDetailInfoView: View {
    private let selectedEvent: DetailEventUIO
    
    init(selectedEvent: DetailEventUIO) {
        self.selectedEvent = selectedEvent
    }
    
    @State var isFavorite: Bool = false
    var body: some View {
        VStack(spacing: 0){
            titleCell.padding(.top, 24)
            infoCell(title: "날짜", content: "\(selectedEvent.startDate) ~ \(selectedEvent.endDate)")
                .padding(.top, 12)
            infoCell(title: "장소", content: "\(selectedEvent.placeName)")
                .padding(.top, 4)
            if let reservationDate = selectedEvent.reservationStartDate {
                infoCell(title: "예매", content: "\(reservationDate)")
                    .padding(.top, 4)
            }
        }
    }
}

extension EventDetailInfoView {
    private var titleCell: some View {
        HStack(alignment: .top, spacing: 20){
            Text("\(selectedEvent.name)")
                .figmaFont(PretendardFont.title(style: .sm))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack{
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .resizable()
                    .frame(width: 21, height: 19)
                    .foregroundStyle(.brand500)
                    .onTapGesture {
                        isFavorite.toggle()
                    }
            }
            .frame(width: 32, height: 32)
        }
        .frame(height: 56)
    }
}

extension EventDetailInfoView {
    private func infoCell(title: String, content: String) -> some View {
        HStack(spacing: 12) {
            Text(title)
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .semibold)))
                .foregroundColor(.gray600)
            Text(content)
                .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                .foregroundColor(.gray300)
            Spacer()
        }
    }
}

#Preview {
    EventDetailInfoView(selectedEvent: .dummy0)
}
