//
//  AccountHTTPRequestRouter.swift
//  KEEV
//
//  Created by 김준성 on 12/26/24.
//

import Foundation

enum AccountHTTPRequestRouter {
    /// 애플로 로그인할 때 사용하는 라우터. code는 `SignInWithApple`을 통해 받을 수 있는 `authorizationCode`입니다.
    case signInWithApple(code: Data)
    /// AccessToken을 갱신할 때 사용하는 라우터
    case refreshAccessToken(refreshToken: String)
    /// 사용자가 회원정보를 기입할 때 사용하는 라우터
    case modifyAccount(accessToken: String, boundary: String, multipartData: Data)
    /// 로그아웃 라우터
    case signOut(accessToken: String)
    /// 회원탈퇴 라우터
    case deleteAccount(accessToken: String)
}

extension AccountHTTPRequestRouter: HTTPRequestable {
    var method: HTTPMethod {
        switch self {
        case .signInWithApple: .post
        case .refreshAccessToken: .post
        case .modifyAccount: .post
        case .signOut: .post
        case .deleteAccount: .delete
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .signInWithApple: ["Content-Type": "application/json"]
        case .refreshAccessToken(let token): ["Authorization": "Bearer \(token)"]
        case .modifyAccount(let token, let boundary, _): [
            "Authorization": "Bearer \(token)",
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]
        case .signOut(let token): ["Authorization": "Bearer \(token)"]
        case .deleteAccount(let token): ["Authorization": "Bearer \(token)"]
        }
    }
    
    var body: Data? {
        switch self {
        case .signInWithApple(let code):
            try? JSONSerialization.data(withJSONObject: ["code": String(data: code, encoding: .utf8)!])
        case .refreshAccessToken: nil
        case .modifyAccount(_, _, let multipartData): multipartData
        case .signOut: nil
        case .deleteAccount: nil
        }
    }
    
    var baseURL: any URLBaseComposable {
        AppEnvironment.keevBaseURL
    }
    
    var path: [String]? {
        switch self {
        case .signInWithApple: ["auth", "signup", "apple"]
        case .refreshAccessToken: ["auth", "reissue"]
        case .modifyAccount: ["user", "register", "userinfo"]
        case .signOut: ["auth", "signOut"]
        case .deleteAccount: ["user", "delete"]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
}
