//
//  CommentSheetView.swift
//  KEEV
//
//  Created by Doran on 11/6/24.
//

import SwiftUI

/// VibeCreateScreen의 코멘트 창을 클릭했을 때 올라오는 시트 뷰
///
/// - Parameters:
///   - textEditorFocus: 텍스트 에디터 포커싱 여부
///   - comment: 유저가 남긴 코멘트
///
/// - Note: FocusState를 사용하여 텍스트 에디터 영역이 아닌 다른 시트의 영역을 터치해도 입력이 가능하게 하였습니다.
/// - Author: Doran
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
                
                // MARK: 헤더
                CommentHeader()
                    .padding(.top, 12)
                ScrollView {
                    
                    // MARK: 코멘트 남기는 영역. 터치시, 텍스트 에디터에 포커싱
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
