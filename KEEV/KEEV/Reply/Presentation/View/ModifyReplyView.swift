//
//  ModifyReplyView.swift
//  KEEV
//
//  Created by 김준성 on 11/19/24.
//

import SwiftUI

struct ModifyReplyView: View {
    let reply: ReplyUIO
    private let sendHandler: (String) -> Void
    
    @State private var text: String
    @FocusState private var isFocused: Bool
    
    init(reply: ReplyUIO, sendHandler: @escaping (String) -> Void) {
        self.reply = reply
        self.text = reply.text
        self.sendHandler = sendHandler
    }
    
    var body: some View {
        ReplyInputView(replyText: $text) { _ in
            sendHandler(text)
        }
    }
}

#Preview {
    ModifyReplyView(reply: .dummy0) { _ in 
        
    }
}
