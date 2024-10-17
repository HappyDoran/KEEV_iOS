//
//  DummyView.swift
//  KEEV
//
//  Created by Doran on 10/16/24.
//

import SwiftUI

struct DummyView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        Button {
            router.popToRoot()
        } label: {
            Text("Go home")
        }
    }
}

#Preview {
    DummyView()
}
