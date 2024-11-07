//
//  CommentSheetView.swift
//  KEEV
//
//  Created by Doran on 11/6/24.
//

import SwiftUI

struct CommentSheetView: View {
    @FocusState private var textEditorFocus: Bool
    @Binding private var comment: String
    
    init(comment: Binding<String>) {
        self._comment = comment
    }
    
    var body: some View {
        ZStack {
            Color.gray800
                .ignoresSafeArea(.all, edges: .all)
            VStack(spacing: 0){
                CommentHeader()
                    .padding(.top, 12)
                ScrollView {
                    CommentSheetBody(comment: $comment, isFocused: $textEditorFocus)
                }
                .onTapGesture {
                    textEditorFocus = true
                }
            }
        }
    }
}

#Preview { CommentSheetView(comment: .constant("")).backgroundForKEEV() }
