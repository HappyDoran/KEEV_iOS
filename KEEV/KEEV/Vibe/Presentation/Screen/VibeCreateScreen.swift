//
//  VibeCreateScreen.swift
//  KEEV
//
//  Created by Doran on 11/5/24.
//

import SwiftUI

struct VibeCreateScreen: View {
    @State private var isPresented = false
    
    var body: some View {
        VStack(spacing: 0) {
            VibeHeader()
            EventSelectCell(isPresented: $isPresented).padding(.top, 16).padding(.horizontal, 16)
            Spacer()
        }
        .fullScreenCover(isPresented: $isPresented) {
            SearchScreen(isPresented: $isPresented, searchContent: .vibe)
        }
        .backgroundForKEEV()
    }
}

#Preview {
    VibeCreateScreen()
}
