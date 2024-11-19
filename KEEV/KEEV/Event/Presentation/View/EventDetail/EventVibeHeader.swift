//
//  EventVibeHeader.swift
//  KEEV
//
//  Created by Doran on 11/18/24.
//

import SwiftUI

/// 이벤트 바이브 헤더를 표시하는 뷰입니다.
///
/// 이 뷰는 바이브의 정렬 옵션과 글쓰기 버튼을 포함합니다.
///
/// - Author: Doran
struct EventVibeHeader: View {
    var body: some View {
        HStack(spacing: 0){
            Button(action: {
                // 정렬 기능을 보여주는 ActionSheet가 올라와야 합니다.
            }){
                HStack(spacing: 0){
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.brand500)
                    Text("최신순")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                        .foregroundColor(.gray500)
                }
            }
            Spacer()
            Button(action: {
                // 버튼을 누르면 바이브 작성 시트(이미지가 선택되어 있음)가 올라오게 작동해야 합니다.
            }){
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.grayBG700)
                    .frame(width: 75, height: 29)
                    .overlay{
                        HStack(spacing: 0){
                            Text("글쓰기")
                                .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium)))
                                .foregroundColor(.brand500)
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.brand500)
                        }
                    }
            }
        }
        .frame(height: 61)
    }
}

#Preview {
    EventVibeHeader()
}
