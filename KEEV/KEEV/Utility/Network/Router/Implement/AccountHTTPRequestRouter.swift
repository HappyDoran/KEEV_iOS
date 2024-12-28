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
    /// 이 앱을 처음 사용하는 사용자가 회원정보를 기입할 때 사용하는 라우터
    case signUp(accessToken: String, boundary: String, multipartData: Data)
}

extension AccountHTTPRequestRouter: HTTPRequestable {
    var method: HTTPMethod {
        switch self {
        case .signInWithApple: .post
        case .refreshAccessToken: .post
        case .signUp: .post
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .signInWithApple: ["Content-Type": "application/json"]
        case .refreshAccessToken(let token): ["Authorization": "Bearer \(token)"]
        case .signUp(let token, let boundary, _): [
            "Authorization": "Bearer \(token)",
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]
        }
    }
    
    var body: Data? {
        switch self {
        case .signInWithApple(let code):
            try? JSONSerialization.data(withJSONObject: ["code": String(data: code, encoding: .utf8)!])
        case .refreshAccessToken: nil
        case .signUp(_, _, let multipartData): multipartData
        }
    }
    
    var baseURL: any URLBaseComposable {
        AppEnvironment.keevBaseURL
    }
    
    var path: [String]? {
        switch self {
        case .signInWithApple: ["auth", "signup", "apple"]
        case .refreshAccessToken: ["auth", "reissue"]
        case .signUp: ["user", "register", "userinfo"]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
}
