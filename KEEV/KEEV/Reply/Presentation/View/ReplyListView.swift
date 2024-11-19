//
//  ReplyListView.swift
//  KEEV
//
//  Created by 김준성 on 11/19/24.
//

import SwiftUI

struct ReplyListView: View {
    let userID: Int
    @Binding var replies: [ReplyUIO]
    private let moreTabHandler: (Int, ReplyUIO) -> Void
    
    init(
        userID: Int,
        replies: Binding<[ReplyUIO]>,
        moreTabHandler: @escaping (Int, ReplyUIO) -> Void
    ) {
        self.userID = userID
        self._replies = replies
        self.moreTabHandler = moreTabHandler
    }
    
    
    var body: some View {
        LazyVStack {
            ForEach(0..<replies.count, id: \.self) { index in
                ReplyListCell(userID: userID, reply: replies[index]) {
                    moreTabHandler(index, replies[index])
                }
                
                if index < replies.count - 1 {
                    Divider()
                        .padding(.vertical, 20)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(.grayBG800)
    }
}

#Preview {
    ReplyListView(userID: 2, replies: .constant([
        .dummy0, .dummy1, .dummy2
    ])) { _, _ in
        
    }
}
