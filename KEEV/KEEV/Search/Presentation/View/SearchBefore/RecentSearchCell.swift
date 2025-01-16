//
//  RecentSearchCell.swift
//  KEEV
//
//  Created by Doran on 11/3/24.
//

import SwiftUI

/// 최근 검색한 검색어를 보여주는 셀뷰
///
/// - Parameters:
///   - search: 최근 검색한 텍스트와 검색한 날짜를 담고 있는 모델
///   - onClick: 셀 클릭시 발생하는 함수
///   - onDelete: 셀 삭제시 발생하는 함수
///
/// - Author: Doran
struct RecentSearchCell: View {
    private let search: RecentSearch
    private let onClick: () -> Void
    private let onDelete: () -> Void
    
    init(search: RecentSearch, onClick: @escaping () -> Void, onDelete: @escaping () -> Void) {
        self.search = search
        self.onClick = onClick
        self.onDelete = onDelete
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // MARK: 최근 검색한 텍스트
            Button(action: onClick ){
                Text(search.term)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                    .foregroundColor(.gray100)
                
                Spacer()
                
                Text(search.date.toString(format: "MM.dd"))
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                    .foregroundColor(.gray500)
            }
            
            // MARK: 최근 검색한 텍스트 지우기
            Button(action: onDelete ){
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 8, height: 8)
                    .foregroundColor(.gray500)
            }
            .frame(width: 20, height: 20)
            .padding(.leading, 12)
        }
        .frame(height: 45)
    }
}

#Preview {
    RecentSearchCell(search: RecentSearch(term: "세상에서 제일 재밌는 공연", date: Date()), onClick: {}, onDelete: {})
        .backgroundForKEEV()
}
