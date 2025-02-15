//
//  SignInSheetScreen.swift
//  KEEV
//
//  Created by 김준성 on 2/14/25.
//

import SwiftUI

struct SignInSheetScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    @Injected private var accountService: any AccountServiceProtocol
    
    @State var status: SignInStatus?
    @State private var error: Error? = nil
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss.callAsFunction()
                } label: {
                    Label("닫기", systemImage: "xmark")
                }
                .font(.system(size: 22, weight: .medium))
                .tint(Color.gray100)
                .labelStyle(.iconOnly)

                Spacer()
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            Image("LogoLargeImage")
                .resizable()
                .frame(width: 250, height: 103.5)
            
            Spacer()
            
            AppleLoginButton { (email, user, token, code) in
                Task {
                    do {
                        status = try await accountService.signInWithApple(email: email, user: user, identityToken: token, authorizationCode: code)
                    } catch let failToSignIn {
                        error = failToSignIn
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
            
            TermAndCondition()
        }
        .backgroundForKEEV()
        .alertForError($error)
    }
}

#Preview {
    SignInSheetScreen()
}
