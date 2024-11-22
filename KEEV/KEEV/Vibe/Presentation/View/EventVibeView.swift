//
//  EventVibeView.swift
//  KEEV
//
//  Created by Doran on 11/18/24.
//

import SwiftUI

/// 바이브 뷰
///
/// - Parameter vibeData: 바이브 객체
///
/// - Author: Doran
struct EventVibeView: View {
    let eventID: String
    @State private var vibes: [VibeUIO]? = nil
    
    init(
        eventID: String,
        vibes: [VibeUIO]? = nil
    ) {
        self.eventID = eventID
        self.vibes = vibes
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if let vibes {
                VStack(spacing: 0){
                    ForEach(0..<min(vibes.count, 5), id: \.self) { index in
                        NavigationLink {
                            VibeDetailScreen(vibe: vibes[index]) { vibe in
                                self.vibes?[index] = vibe
                            } onDelete: { _ in
                                self.vibes?.remove(at: index)
                            }

                        } label: {
                            EventVibeCell(vibeData: vibes[index])
                        }
                    }
                }
            } else {
                ProgressView()
                    .onAppear {
                        // 서비스가 이벤트의 바이브를 찾는 로직
                        vibes = VibeUIO.dummies
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#Preview {
    ScrollView(showsIndicators: false) {
        EventVibeView(eventID: "efefweaff")
    }
}
