//
//  VibeCreateScreen.swift
//  KEEV
//
//  Created by Doran on 11/5/24.
//

import SwiftUI

struct VibeCreateScreen: View {
    @State private var showingFirst = false
    @State private var showingSecond = false

    var body: some View {
        VStack {
            Text("")
            Button("공연을 선택해주세요") {
                showingFirst = true
            }
        }
        .fullScreenCover(isPresented: $showingFirst) {
            SearchScreen(isPresented: $showingFirst, searchContent: .vibe)
        }
    }
}

#Preview {
    VibeCreateScreen()
}
