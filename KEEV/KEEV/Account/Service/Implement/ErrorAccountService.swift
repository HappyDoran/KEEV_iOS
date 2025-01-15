//
//  ErrorAccountService.swift
//  KEEV
//
//  Created by 김준성 on 1/8/25.
//

import Foundation
import UIKit

/// 항상 에러를 반환하는 목 서비스입니다.
final class ErrorAccountService: AccountServiceProtocol, KEEVErrorHandler {
    typealias Layer = ErrorAccountService
    
    static let layer: LayerType = .service(of: "TempAccountService")
    
    
    func autoSignIn() async -> SignInStatus {
        .failed
    }
    
    func signInWithApple(email: String?, user: String, identityToken: Data, authorizationCode: Data) async throws -> SignInStatus {
        try await doAsyncWithException(caller: "signInWithApple") {
            let (_, _) = try await requestWithStatusCode(router: AccountHTTPRequestRouter.signInWithApple(email: email, code: authorizationCode))
            return SignInStatus.ok(user: .dummy0)
        }
    }
    
    func signUp(email: String, nickname: String, profileImage: UIImage?, backgroundImage: UIImage?, description: String) async throws -> SignInStatus {
        try await doAsyncWithException(caller: "signUp") {
            let (_, _) = try await requestWithStatusCode(router: AccountHTTPRequestRouter.signInWithApple(email: nil, code: "eee".data(using: .utf8)!))
            return SignInStatus.ok(user: .dummy0)
        }
    }
    
    func updateProfile(nickname: String, profileImage: UIImage?, backgroundImage: UIImage?, description: String) async throws -> DetailUserUIO {
        try await doAsyncWithException(caller: "updateProfile") {
            let (_, _) = try await requestWithStatusCode(router: AccountHTTPRequestRouter.signInWithApple(email: nil, code: "eee".data(using: .utf8)!))
            return DetailUserUIO.dummy0
        }
    }
    
    func signOut() async throws {
        
    }
    
    func deleteAccount() async throws {
        
    }
    
    func requestWithStatusCode(router: HTTPRequestable) async throws -> (Int, Data) {
        throw KEEVError(
            layer: .utility(of: "NetworkUtility"),
            caller: "request",
            occurPoint: .remote(code: 400, message: "token is invalid"),
            previousError: nil
        )
    }
}
