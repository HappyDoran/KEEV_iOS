//
//  TermsOfUseView.swift
//  KEEV
//
//  Created by Yune Cho on 11/9/24.
//

import SwiftUI

struct TermsOfUseView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("여기에 서비스 이용약관을 보여줄겁니다.")
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .figmaFont(PretendardFont.title(style: .xs))
                        .foregroundStyle(.gray100)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("서비스 이용약관")
                    .figmaFont(PretendardFont.title(style: .xs))
                    .foregroundStyle(.gray100)
            }
        }
        .backgroundForKEEV()
    }
}

#Preview {
    TermsOfUseView()
}
