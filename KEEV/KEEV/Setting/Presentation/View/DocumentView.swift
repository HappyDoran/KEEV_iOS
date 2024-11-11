//
//  DocumentView.swift
//  KEEV
//
//  Created by Yune Cho on 11/9/24.
//

import SwiftUI

/// 긴 문서의 텍스트를 보여주는 뷰
///
/// 서비스 이용약관, 개인정보 처리방침과 같이 긴 텍스트를 보여주는 뷰입니다.
///
/// - Note: ScrollView와 Text를 사용할 경우 뷰를 렌더링하는데 시간이 걸리는 문제가 있어서 TextEditor를 사용하고 포커싱이 안되도록 처리하는 방식을 사용하였습니다.
/// - Author: 라움
struct DocumentView: View {
    private let title: String
    private let text: String
    
    init(title: String, text: String) {
        self.title = title
        self.text = text
    }
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            FullScreenCoverTopView(title: title)
            
            TextEditor(text: .constant(text))
                .scrollContentBackground(.hidden)
                .selectionDisabled(true)
                .focused($isFocused)
                .onChange(of: isFocused, {
                    isFocused = false
                })
                .foregroundStyle(.gray500)
                .padding(.horizontal, 16)
        }
        .backgroundForKEEV()
    }
}

#Preview {
    DocumentView(title: "test", text: "test")
}
