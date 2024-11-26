//
//  SearchCell.swift
//  KEEV
//
//  Created by Doran on 11/3/24.
//

import SwiftUI

/// 검색을 하는 도중 나오는 키워드 검색 뷰
///
/// - Parameters:
///   - event: 키워드를 토대로 나오는 이벤트 정보
///   - onClick: 셀 클릭시 발생하는 함수
///
/// - Author: Doran
struct SearchCell: View {
    private let text: String
    
    init(text: String){
        self.text = text
    }
    
    var body: some View {
        HStack(spacing: 12){
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .foregroundColor(.gray500)
            
            Text(text)
                .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .regular)))
                .foregroundStyle(.gray100)
                .lineLimit(1)
            
            Spacer()
        }
    }
}

#Preview {
    SearchCell(text: SimpleEventUIO.dummy0.name)
        .backgroundForKEEV()
}
