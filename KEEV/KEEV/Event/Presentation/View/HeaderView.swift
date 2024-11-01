//
//  HeaderView.swift
//  KEEV
//
//  Created by Doran on 11/1/24.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack(spacing: 0) {
            Image("LogoImage")
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 32)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "magnifyingglass")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xlarge, bodyWeight: .semibold)))
                    .font(.system(size: 20))
                    .foregroundColor(Color.gray100)
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    HeaderView()
        .backgroundForKEEV()
}
