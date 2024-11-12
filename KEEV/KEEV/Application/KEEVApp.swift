//
//  KEEVApp.swift
//  KEEV
//
//  Created by 김준성 on 10/15/24.
//

import SwiftUI

@main
struct KEEVApp: App {
    init() {
        AppEnvironment.setupDependency()
    }
    
    @State private var showScreen = false
    
    var body: some Scene {
        WindowGroup {
//            EntryView()
            VStack {
                Button {
                    showScreen.toggle()
                } label: {
                    Text("Show Screen")
                }
                .fullScreenCover(isPresented: $showScreen) {
                    VibeCreateScreen()
                }
            }
        }
    }
}
