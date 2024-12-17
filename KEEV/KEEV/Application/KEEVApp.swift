//
//  KEEVApp.swift
//  KEEV
//
//  Created by 김준성 on 10/15/24.
//

import SwiftUI

@main
struct KEEVApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    init() {
        AppEnvironment.setupDependency()
    }
    
    var body: some Scene {
        WindowGroup {
        }
    }
}
