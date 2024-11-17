//
//  EventDetailScreen.swift
//  KEEV
//
//  Created by Doran on 11/17/24.
//

import SwiftUI

enum Menu: Int, CaseIterable {
    case menu1 = 0
    case menu2 = 1

  var title: String {
      switch self {
        case .menu1: return "공연 상세"
        case .menu2: return "바이브"
        }
    }
}

struct EventDetailScreen: View {
    private var selectedEvent: DetailEventUIO
    @State private var activeMenu = Menu.menu1
    
    init(selectedEvent: DetailEventUIO) {
        self.selectedEvent = selectedEvent
    }
    
    var body: some View {
        
        VStack(spacing: 0){
            HeaderTabView(activeMenu: $activeMenu)
            switch activeMenu {
            case .menu1:
                EventDetailThumbnail(selectedEvent: selectedEvent)
                DetailInfoView(selectedEvent: selectedEvent)
                    .padding(.horizontal, 20)
                CommonButton(title: isDisabled() ? "작성완료" : "글쓰기", action: { print("hello world")}, style: .maxWidth, disabled: isDisabled())
                    .padding(EdgeInsets(top: 56, leading: 16, bottom: 42, trailing: 16))
            case .menu2:
                EmptyView()
            }
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(selectedEvent.name)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .regular)))
                    .frame(width: 277)
                    .foregroundStyle(.gray300)
                    
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.gray100)
                }
            }
        }
        .toolbarRole(.editor)
    }
}



extension EventDetailScreen {
    private func isDisabled() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        guard let eventStartDate = dateFormatter.date(from: selectedEvent.startDate) else {
            return false
        }
        
        return eventStartDate > Date()
    }
}


#Preview {
    EventDetailScreen(selectedEvent: .dummy1)
}
