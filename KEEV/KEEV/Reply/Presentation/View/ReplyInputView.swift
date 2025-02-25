//
//  ReplyInputView.swift
//  KEEV
//
//  Created by 김준성 on 11/19/24.
//

import SwiftUI

struct ReplyInputView: LoginCheckableView {
    @Environment(AppState.self) var appState
    
    @Binding var replyText: String
    var isFocused: FocusState<Bool>.Binding
    private var isLogin: Bool {
        if case .ok = appState.loginStatus {
            return true
        } else {
            return false
        }
    }
    private let sendHandler: (String) -> Void
    
    init(replyText: Binding<String>, isFocused: FocusState<Bool>.Binding, sendHandler: @escaping (String) -> Void) {
        self._replyText = replyText
        self.isFocused = isFocused
        self.sendHandler = sendHandler
    }
    
    var body: some View {
        HStack {
            replyTextField
                .id(appState.loginStatus)
                .figmaFont(
                    PretendardFont.body(
                        style: .init(bodySize: .medium, bodyWeight: .regular)
                    )
                )
                .focused(isFocused)
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
                .frame(height: 46)
        )
    }
}

private extension ReplyInputView {
    @ViewBuilder
    var replyTextField: some View {
        if isLogin {
            TextField(
                "",
                text: $replyText,
                prompt: Text("댓글을 입력해주세요")
                    .foregroundStyle(.gray700)
            )
        } else {
            Text("로그인이 필요한 서비스입니다.")
                .foregroundStyle(.gray700)
                .onTapGesture { _ = appState.checkLoginStatus() }
        }
    }
    
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
        isLogin && !reply.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

#Preview {
    ReplyInputView(replyText: .constant(""), isFocused: FocusState<Bool>().projectedValue) { _ in
        
    }
    .environment(AppState())
}
