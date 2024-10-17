//
//  ContentView.swift
//  KEEV
//
//  Created by 김준성 on 10/15/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Hello, world!")
            
            Button {
                router.push(.dummyScreen)
            } label: {
                Text("Go to Dummy Screen")
            }

            Button {
                router.push(.dummyView)
            } label: {
                Text("Go to Dummy View")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
