//
//  CreateVibeButtonView.swift
//  KEEV
//
//  Created by Doran on 2/15/25.
//

import SwiftUI

/// 글쓰기 버튼 UI
///
///  해당 뷰는 Navigation으로도 사용이 가능하고, 버튼으로도 사용이 가능하게끔 하기 위해 액션은 따로 없습니다.
///
/// - Author: Doran
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
