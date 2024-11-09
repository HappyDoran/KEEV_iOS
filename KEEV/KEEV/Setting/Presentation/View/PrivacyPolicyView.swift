//
//  PrivacyPolicyView.swift
//  KEEV
//
//  Created by Yune Cho on 11/9/24.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("여기에 개인정보 처리방침을 보여줄겁니다.")
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
                Text("개인정보 처리방침")
                    .figmaFont(PretendardFont.title(style: .xs))
                    .foregroundStyle(.gray100)
            }
        }
        .backgroundForKEEV()
    }
}

#Preview {
    PrivacyPolicyView()
}
