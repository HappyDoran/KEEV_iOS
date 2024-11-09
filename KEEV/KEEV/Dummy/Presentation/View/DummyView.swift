//
//  DummyView.swift
//  KEEV
//
//  Created by Doran on 10/16/24.
//

import SwiftUI

struct DummyView: View {
    
    var body: some View {
//        Text("Hello World")
        NavigationStack {
            NavigationLink("설정") {
                SettingScreen()
            }
        }
        .tint(.gray100)
    }
}

#Preview {
    DummyView()
}
