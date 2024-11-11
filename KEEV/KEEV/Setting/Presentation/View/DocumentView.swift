//
//  DocumentView.swift
//  KEEV
//
//  Created by Yune Cho on 11/9/24.
//

import SwiftUI

struct DocumentView: View {
    private let title: String
    private let termsOfUse: String
    
    init(title: String, termsOfUse: String) {
        self.title = title
        self.termsOfUse = termsOfUse
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            FullScreenCoverTopView(title: title)
            
            TextEditor(text: .constant(termsOfUse))
                .scrollContentBackground(.hidden)
                .selectionDisabled()
                .foregroundStyle(.gray500)
                .padding(.horizontal, 16)
        }
        .backgroundForKEEV()
    }
}

#Preview {
    DocumentView(title: "test", termsOfUse: "test")
}
