//
//  ReplyInputView.swift
//  KEEV
//
//  Created by 김준성 on 11/19/24.
//

import SwiftUI

struct ReplyInputView: View {
    @Binding var replyText: String
    private let sendHandler: (String) -> Void
    
    init(replyText: Binding<String>, sendHandler: @escaping (String) -> Void) {
        self._replyText = replyText
        self.sendHandler = sendHandler
    }
    
    var body: some View {
        HStack {
            TextField(
                "댓글을 입력해주세요.",
                text: $replyText
            )
            .figmaFont(
                PretendardFont.body(
                    style: .init(bodySize: .medium, bodyWeight: .regular)
                )
            )
            .padding(.vertical, 12)
            .padding(.leading, 16)
            .foregroundStyle(.gray100)
            
            Spacer()
            
            replySendButton
                .padding(.trailing, 11)
        }
        .background(
            RoundedRectangle(cornerRadius: 9999)
                .foregroundStyle(.grayBG700)
        )
        
    }
}

private extension ReplyInputView {
    var replySendButton: some View {
        Button {
            sendHandler(replyText)
        } label: {
            Image(systemName: "arrow.up.circle.fill")
                .resizable()
                .frame(width: 26, height: 26)
                .foregroundStyle(isAvailableReply(replyText) ? .gray100 : .grayBG600)
        }
        .disabled(!isAvailableReply(replyText))
    }
}

private extension ReplyInputView {
    func isAvailableReply(_ reply: String) -> Bool {
        !reply.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

#Preview {
    ReplyInputView(replyText: .constant("jjjj")) { _ in
        
    }
}
