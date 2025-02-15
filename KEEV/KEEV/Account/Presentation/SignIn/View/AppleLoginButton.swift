//
//  AppleLoginButton.swift
//  KEEV
//
//  Created by 김준성 on 2/14/25.
//

import SwiftUI
import AuthenticationServices

/// 애플로 로그인 버튼
///
/// 클로저를 받습니다. 클로저의 인자는 앞에서부터 `String?`, `String`, `Data`, `Data` 입니다.
/// 각 인자가 주는 사용처는 **email, user, token, code** 입니다.
/// 
/// - Parameters:
///   - completionHandler: 애플로 로그인을 성공했을 때 넘겨주는 정보로 처리할 클로저
///
/// - Author: newJunsung
struct AppleLoginButton: View {
    let completionHandler: (String?, String, Data, Data) -> Void
    
    var body: some View {
        SignInWithAppleButton(.signIn) { request in
            request.requestedScopes = [.email]
        } onCompletion: { result in
            switch result {
            case .success(let authorization):
                switch authorization.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    let email = appleIDCredential.email
                    let user = appleIDCredential.user
                    let token = appleIDCredential.identityToken!
                    let code = appleIDCredential.authorizationCode!
                    
                    completionHandler(email, user, token, code)
                    
                default: break
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
        .figmaFont(
            PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .semibold))
        )
        .frame(height: 54)
        .signInWithAppleButtonStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    AppleLoginButton { _, _, _, _ in
        
    }
}
