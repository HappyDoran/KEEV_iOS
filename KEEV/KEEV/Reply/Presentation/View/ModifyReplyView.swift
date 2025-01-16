//
//  ModifyReplyView.swift
//  KEEV
//
//  Created by 김준성 on 11/19/24.
//

import SwiftUI

struct ModifyReplyView: View {
    let reply: ReplyUIO
    var isFocused: FocusState<Bool>.Binding
    private let sendHandler: (String) -> Void
    
    @State private var text: String
    
    init(reply: ReplyUIO, isFocused: FocusState<Bool>.Binding, sendHandler: @escaping (String) -> Void) {
        self.reply = reply
        self.text = reply.text
        self.isFocused = isFocused
        self.sendHandler = sendHandler
    }
    
    var body: some View {
        ReplyInputView(replyText: $text, isFocused: isFocused) { _ in
            sendHandler(text)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    ModifyReplyView(reply: .dummy0, isFocused: FocusState<Bool>().projectedValue) { _ in 
        
    }
}
