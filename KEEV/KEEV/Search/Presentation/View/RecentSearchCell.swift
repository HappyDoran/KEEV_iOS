//
//  RecentSearchCell.swift
//  KEEV
//
//  Created by Doran on 11/3/24.
//

import SwiftUI

struct RecentSearchCell: View {
    var search: RecentSearch
    var onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            Text(search.term)
                .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                .foregroundColor(.gray100)
            
            Spacer()
            
            Text(search.date.toString(format: "MM.dd"))
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                .foregroundColor(.gray500)
            
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
    RecentSearchCell(search: RecentSearch(term: "세상에서 제일 재밌는 공연", date: Date()), onDelete: {})
        .backgroundForKEEV()
}
