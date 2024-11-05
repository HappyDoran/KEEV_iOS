//
//  SearchField.swift
//  KEEV
//
//  Created by Doran on 11/2/24.
//

import SwiftUI

/// 검색어 입력란
///
/// - Parameters:
///   - text: 검색한 텍스트
///   - searchStatus: 검색어 입력란의 상태를 나열하는 열거형
///
/// 검색을 완료했는지(onSubmit), 검색어가 비어있는지에 따라 searchStatus값이 변동
///
/// - Author: Doran
struct SearchField: View {
    @Binding private var text: String
    @Binding private var searchStatus: EventSearchStatus
    private var isFocused: FocusState<Bool>.Binding
    
    init(text: Binding<String>, searchStatus: Binding<EventSearchStatus>, isFocused: FocusState<Bool>.Binding){
        self._text = text
        self._searchStatus = searchStatus
        self.isFocused = isFocused
    }
    
    var body: some View {
        Rectangle()
            .frame(height: 56)
            .foregroundStyle(.gray900)
            .overlay {
                HStack(spacing: 0) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 16)
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .semibold)))
                        .foregroundColor(.gray300)
                        .padding(.leading, 6)
                    
                    TextField("", text: $text, prompt: Text("공연 이름 검색하기").foregroundStyle(.gray700))
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .medium)))
                        .focused(isFocused)
                        .accentColor(.brand500)
                        .foregroundStyle(.gray100)
                        .keyboardType(.default)
                        .padding(.leading, 14)

                    
                    if !text.isEmpty {
                        Button(action: {
                            text = ""
                            searchStatus = .beforeSearch
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 17.14, height: 17.14)
                                .foregroundColor(.gray700)
                                .padding(.trailing, 3.43)
                        }
                    }
                }
                .padding(16)
            }
    }
}

#Preview {
    SearchField(text: .constant(""), searchStatus: .constant(.beforeSearch), isFocused:  FocusState<Bool>().projectedValue)
        .backgroundForKEEV()
}
