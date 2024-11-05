//
//  SearchHeader.swift
//  KEEV
//
//  Created by Doran on 11/2/24.
//

import SwiftUI

/// 이벤트 검색 화면에 들어가는 헤더
///
/// - Parameters:
///   - isPresented: 풀스크린시트의 열림 여부
///
/// 취소 버튼 클릭시 풀스크린 시트가 내려가면서 EventInfoScreen이 나타납니다.
///
/// - Author: Doran
struct SearchHeader: View {
    var title: String
    @Binding private var isPresented: Bool
    
    init(title: String, isPresented: Binding<Bool>) {
        self.title = title
        self._isPresented = isPresented
    }
    
    var body: some View {
        ZStack {
            Text(title)
                .figmaFont(PretendardFont.title(style: .xs)).foregroundColor(.gray100)
            
            // MARK: 검색 시트 아래로 내리는 버튼
            HStack {
                Spacer()
                Button(action: {
                    isPresented.toggle()
                }) {
                    Text("취소")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .regular)))
                        .foregroundColor(.brand500)
                }
            }
            .padding(.trailing, 16)
            .frame(height: 48)
        }
    }
}

#Preview {
    SearchHeader(title: "검색", isPresented: .constant(false))
        .backgroundForKEEV()
}
