//
//  KEEVApp.swift
//  KEEV
//
//  Created by 김준성 on 10/15/24.
//

import SwiftUI

@main
struct KEEVApp: App {
    @StateObject private var router = NavigationRouter()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                ContentView()
                    .navigationDestination(for: NavigationRouter.Route.self) { destination in
                        switch destination {
                        case .dummyScreen:
                            DummyScreen()
                        case .dummyView:
                            DummyView()
                        }
                    }
            }
        }
        .environmentObject(router)
    }
}
