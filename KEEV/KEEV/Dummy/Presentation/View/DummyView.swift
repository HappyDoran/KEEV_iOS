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
            NavigationLink {
                ReportScreen(reportType: .vibe)
            } label: {
                Text("신고하기")
            }
        }
        .tint(.gray100)
    }
}

#Preview {
    DummyView()
}
