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
    
    @Binding var status: SignInStatus?
    @State private var error: Error? = nil
    
    var body: some View {
        VStack {
            switch status {
            case .created: SignUpScreen(status: .created)
            case .lookAround, .failed: loginScreen
            default: Text("로그인이 완료되었습니다.").onAppear(perform: dismiss.callAsFunction)
            }
        }
        .backgroundForKEEV()
        .alertForError($error)
    }
    
    private var loginScreen: some View {
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
                        _ = try await accountService.signInWithApple(email: email, user: user, identityToken: token, authorizationCode: code)
                    } catch let failToSignIn {
                        error = failToSignIn
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
            
            TermAndCondition()
        }
    }
}

#Preview {
    SignInSheetScreen(status: .constant(.created))
}
