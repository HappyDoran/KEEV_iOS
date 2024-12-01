//
//  KEEVPreview.swift
//  KEEV
//
//  Created by 김준성 on 11/27/24.
//

import SwiftUI

struct KEEVPreview<Content: View>: View {
    let content: () -> Content
    
    init(_ content: @escaping () -> Content) {
        AppEnvironment.setupDependency()
        self.content = content
    }
    
    var body: some View {
        NavigationStack {
            content()
        }
        .tint(.gray100)
    }
}

#Preview {
    KEEVPreview {
        EntryView()
    }
}
