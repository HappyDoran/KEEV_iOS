//
//  NewAccountHTTPRouter.swift
//  KEEV
//
//  Created by 김준성 on 3/13/25.
//

import Foundation

enum NewAccountHTTPRequestRouter {
    /// 애플로 로그인할 때 사용하는 라우터. code는 `SignInWithApple`을 통해 받을 수 있는 `authorizationCode`입니다.
    case signInWithApple(identityToken: Data)
    /// 사용가 회원가입을 할 때 사용하는 라우터. multipartData에는 idToken, 닉네임, 이메일, 프로필 사진이 들어가야 합니다.
    case signUp(boundary: String, multipartData: Data)
    /// AccessToken을 갱신할 때 사용하는 라우터
    case refreshAccessToken(refreshToken: String)
    /// 사용자가 회원정보를 수정할 때 사용하는 라우터
    case modifyAccount(accessToken: String, boundary: String, multipartData: Data)
    /// 로그아웃 라우터
    case logout(accessToken: String)
    /// 회원탈퇴 라우터
    case deleteAccount(accessToken: String)
}

extension NewAccountHTTPRequestRouter: HTTPRequestable {
    var method: HTTPMethod {
        switch self {
        case .signInWithApple: .post
        case .signUp: .post
        case .refreshAccessToken: .post
        case .modifyAccount: .post
        case .logout: .post
        case .deleteAccount: .delete
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .signInWithApple: ["Content-Type": "application/json"]
        case .signUp(let boundary, _): [
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]
        case .refreshAccessToken(let token): ["Authorization": "Bearer \(token)"]
        case .modifyAccount(let token, let boundary, _): [
            "Authorization": "Bearer \(token)",
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]
        case .logout(let token): ["Authorization": "Bearer \(token)"]
        case .deleteAccount(let token): ["Authorization": "Bearer \(token)"]
        }
    }
    
    var body: Data? {
        switch self {
        case .signInWithApple(let identityToken):
            let json: [String: Any] = [
                "idToken": String(data: identityToken, encoding: .utf8)!
            ]
            
            return try? JSONSerialization.data(withJSONObject: json)
        case .signUp(_, let multipartData): return multipartData
        case .refreshAccessToken: return nil
        case .modifyAccount(_, _, let multipartData): return multipartData
        case .logout: return nil
        case .deleteAccount: return nil
        }
    }
    
    var baseURL: any URLBaseComposable {
        AppEnvironment.keevBaseURL
    }
    
    var path: [String]? {
        switch self {
        case .signInWithApple: ["open-api", "auth", "apple"]
        case .signUp: ["open-api", "auth", "sign-up"]
        case .refreshAccessToken: ["api", "auth", "token"]
        case .modifyAccount: ["user", "register", "userinfo"]
        case .logout: ["auth", "logout"]
        case .deleteAccount: ["user", "delete"]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
}
