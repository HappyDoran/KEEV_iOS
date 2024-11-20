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
    private let vibeData: [VibeUIO] = VibeUIO.dummies
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0){
                ForEach(0..<min(vibeData.count, 5), id: \.self) { index in
                    EventVibeCell(vibeData: vibeData[index])
                }
            }
        }
    }
}

#Preview {
    ScrollView(showsIndicators: false) {
        EventVibeView()
    }
}
