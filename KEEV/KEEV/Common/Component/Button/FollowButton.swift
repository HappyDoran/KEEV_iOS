//
//  FollowButton.swift
//  KEEV
//
//  Created by Yune Cho on 3/8/25.
//

import SwiftUI

/// 팔로우 버튼
///
/// 다른 유저를 팔로우 하는지 여부를 표시해주고 탭할 시에 팔로우/언팔로우 동작을 수행하는 버튼입니다.
///
/// - Author: 라움
struct FollowButton: View {
    let isFollowing: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            RoundedRectangle(cornerRadius: 50)
                .frame(width: 63, height: 29)
                .foregroundStyle(isFollowing ? .grayBG900 : .gray50)
                .overlay {
                    Text(isFollowing ? "팔로잉" : "팔로우")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .semibold)))
                        .foregroundStyle(isFollowing ? .gray300 : .gray950)
                    
                    RoundedRectangle(cornerRadius: 50)
                        .inset(by: 0.5)
                        .stroke(isFollowing ? .gray300 : .gray50, lineWidth: 1)
                }
        }
    }
}

#Preview {
    @Previewable @State var isFollowing: Bool = false
    
    FollowButton(isFollowing: isFollowing, action: { isFollowing.toggle() })
}
