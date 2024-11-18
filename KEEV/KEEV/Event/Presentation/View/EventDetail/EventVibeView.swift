//
//  EventVibeView.swift
//  KEEV
//
//  Created by Doran on 11/18/24.
//

import SwiftUI

struct EventVibeView: View {
    private let VibeData: [VibeUIO] = [.dummy0, .dummy1, .dummy2]
    
    var body: some View {
        
        VStack(spacing: 0){
            ForEach(0..<min(VibeData.count, 3), id: \.self) { index in
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 356)
                    .foregroundColor(.gray800)
                    .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    ScrollView(showsIndicators: false) {
        EventVibeView()
    }
}
