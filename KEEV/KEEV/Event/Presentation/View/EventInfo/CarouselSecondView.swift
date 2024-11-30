//
//  CarouselSecondView.swift
//  KEEV
//
//  Created by Doran on 11/30/24.
//

import SwiftUI

struct CarouselSecondView: View {
    @Injected private var eventService: any EventServiceProtocol
    @State private var events: [SimpleEventUIO] = SimpleEventUIO.dummies
    var body: some View {
        VStack(spacing: 0){
            Rectangle().frame(height: 15).foregroundColor(.grayBG800)
            ForEach(events) { event in
                EventListCell(event: event)
            }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
        }
        .onAppear{
           //필터링된 이벤트 불러오기
        }
    }
}

#Preview {
    CarouselSecondView()
}
