//
//  CreateVibeButtonView.swift
//  KEEV
//
//  Created by Doran on 2/15/25.
//

import SwiftUI

struct CreateVibeButtonView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.grayBG700)
            .frame(width: 75, height: 29)
            .overlay{
                HStack(spacing: 2) {
                    Text("글쓰기")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 12, weight: .semibold))
                        .padding(.bottom, 1.4)
                }
                .foregroundColor(.brand500)
            }
    }
}
