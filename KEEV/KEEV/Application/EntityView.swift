//
//  EntityView.swift
//  KEEV
//
//  Created by Doran on 11/9/24.
//

import SwiftUI

struct EntityView: View {
    @State private var isPresented = false
    @State private var selectedItem = "info"
    @State private var oldSelectedItem = "info"
    
    init() {
        let appearance = UITabBarAppearance()
        let tabBar = UITabBar()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(.gray950)
        appearance.shadowColor = UIColor(.gray500)
        
        tabBar.standardAppearance = appearance;
        
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedItem) {
                EventInfoScreen()
                    .tabItem {
                        TabbedItem.label(for: .info)
                    }
                    .tag(TabbedItem.info.rawValue)
                Text("")
                    .tabItem {
                        TabbedItem.label(for: .write)
                    }
                    .tag(TabbedItem.write.rawValue)
                DummyView()
                    .tabItem {
                        TabbedItem.label(for: .profile)
                    }
                    .tag(TabbedItem.profile.rawValue)
            }
            .accentColor(.brand500)
        }
        .onChange(of: selectedItem) { _, newValue in
            if newValue == TabbedItem.write.rawValue {
                isPresented = true
                selectedItem = oldSelectedItem
            } else {
                oldSelectedItem = newValue
            }
        }
        .sheet(isPresented: $isPresented) {
            ContentView()
        }
    }
}

#Preview {
    EntityView()
}
