//
//  DummyScreen.swift
//  KEEV
//
//  Created by Doran on 10/16/24.
//

import SwiftUI

struct DummyScreen: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        Button {
            router.pop()
        } label: {
            Text("Go back")
        }
    }
}

#Preview {
    DummyScreen()
}
