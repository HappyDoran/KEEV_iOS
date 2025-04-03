//
//  CreateVibeButtonView.swift
//  KEEV
//
//  Created by Doran on 2/15/25.
//

import SwiftUI

/// 글쓰기 버튼 디자인 타입 열거형
///
/// 글쓰기 버튼 디자인 종류가 2개여서 경우를 나누기 위해 열거형을 만들었습니다.
///
/// - Author: 라움
enum CreateVibeButtonType {
    case purple
    case white
}

/// 글쓰기 버튼 UI
///
///  해당 뷰는 Navigation으로도 사용이 가능하고, 버튼으로도 사용이 가능하게끔 하기 위해 액션은 따로 없습니다.
///
/// - Author: Doran
struct CreateVibeButtonView: View {
    let type: CreateVibeButtonType
    
    @ViewBuilder
    var body: some View {
        switch type {
        case .purple:
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
        case .white:
            Capsule()
                .fill(Color.gray50)
                .frame(width: 86, height: 29)
                .overlay{
                    HStack(spacing: 4) {
                        Text("글쓰기")
                            .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .semibold)))
                        
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 15, weight: .semibold))
                            .padding(.bottom, 1.4)
                    }
                    .foregroundStyle(.grayBG950)
                }
        }
    }
}

#Preview {
    CreateVibeButtonView(type: .purple)
}
