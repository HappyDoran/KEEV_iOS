//
//  CommentSheetView.swift
//  KEEV
//
//  Created by Doran on 11/6/24.
//

import SwiftUI

struct CommentSheetView: View {
    @Binding private var comment: String
    
    init(comment: Binding<String>) {
        self._comment = comment
    }
    
    var body: some View {
        ZStack {
            Color.gray800
                .ignoresSafeArea(.all, edges: .all)
            CommentHeader()
        }
    }
}

#Preview { CommentSheetView(comment: .constant("")).backgroundForKEEV() }
