//
//  EventDetailScreen.swift
//  KEEV
//
//  Created by Doran on 11/17/24.
//

import SwiftUI

enum Menu: Int, CaseIterable {
    case detail = 0
    case vibe = 1

  var title: String {
      switch self {
        case .detail: return "공연 상세"
        case .vibe: return "바이브"
        }
    }
}

struct EventDetailScreen: View {
    private var selectedEvent: DetailEventUIO
    @State private var activeMenu = Menu.detail
    
    init(selectedEvent: DetailEventUIO) {
        self.selectedEvent = selectedEvent
    }
    var body: some View {
        VStack(spacing: 0){
            HeaderTabView(activeMenu: $activeMenu)
                switch activeMenu {
                case .detail:
                    infoView
                case .vibe:
                    vibeView
            }
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
    }
}

extension EventDetailScreen {
    private var infoView: some View {
        ScrollView(showsIndicators: false) {
        EventDetailThumbnail(selectedEvent: selectedEvent)
        EventDetailInfoView(selectedEvent: selectedEvent)
            .padding(.horizontal, 20)
        CommonButton(title: isDisabled ? "작성완료" : "글쓰기", action: { print("hello world")}, style: .maxWidth, disabled: isDisabled)
            .padding(EdgeInsets(top: 56, leading: 16, bottom: 42, trailing: 16))
        }
    }
    
    
    @ViewBuilder
    private var vibeView: some View {
        VStack(spacing: 0){
            if (isDisabled) {
                yetStartVibe.frame(maxHeight: .infinity)
            }
            else {
                EventVibeHeader().padding(.horizontal, 16)
                EventVibeView()
            }
        }
    }
    
    private var yetStartVibe: some View {
        VStack(spacing: 0){
            Text("공연이 시작되지 않았습니다.")
                .figmaFont(PretendardFont.title(style: .sm))
                .foregroundColor(.gray500)
            Text("공연이 시작되면 바이브를 작성할 수 있어요.")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                .foregroundColor(.gray500)
        }
    }
}



extension EventDetailScreen {
    private var isDisabled: Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        guard let eventStartDate = dateFormatter.date(from: selectedEvent.startDate) else {
            return false
        }
        
        return eventStartDate > Date()
    }
}


#Preview {
    NavigationStack {
        EventDetailScreen(selectedEvent: .dummy0)
    }
}
