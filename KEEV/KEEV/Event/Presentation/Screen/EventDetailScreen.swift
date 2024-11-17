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
    private var selectedEvent =  SimpleEventUIO.dummy0
    @State private var activeMenu = Menu.menu1
    
    var body: some View {
        
        VStack(spacing: 0){
            HeaderTabView(activeMenu: $activeMenu)
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

#Preview {
    NavigationStack {
        EventDetailScreen()
//            .backgroundForKEEV()
    }
}
