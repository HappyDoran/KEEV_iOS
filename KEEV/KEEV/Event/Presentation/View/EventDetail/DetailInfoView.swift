//
//  DetailInfoView.swift
//  KEEV
//
//  Created by Doran on 11/17/24.
//

import SwiftUI

struct DetailInfoView: View {
    private let selectedEvent: SimpleEventDTO
    
    init(selectedEvent: SimpleEventDTO) {
        self.selectedEvent = selectedEvent
    }
    
    @State var isFavorite: Bool = false
    var body: some View {
        title.padding(.top, 24)
        infoCell(title: "날짜", content: "\(selectedEvent.startDate.toString(format: "YYYY.MM.dd")) ~ \(selectedEvent.endDate.toString(format: "YYYY.MM.dd"))")
            .padding(.top, 12)
        infoCell(title: "장소", content: "\(selectedEvent.placeName)")
            .padding(.top, 4)
//        infoCell(title: "예매", content: "\(selectedEvent.startDate.toString(format: "YYYY.MM.dd")) ~ \(selectedEvent.endDate.toString(format: "YYYY.MM.dd"))")
//            .padding(.top, 4)
    }
}

extension DetailInfoView {
    private var title: some View {
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

extension DetailInfoView {
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
    DetailInfoView(selectedEvent: .dummy0)
}
