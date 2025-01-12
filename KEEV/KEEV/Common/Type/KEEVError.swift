//
//  KEEVError.swift
//  KEEV
//
//  Created by 김준성 on 1/6/25.
//

import Foundation

/// 키브에서 사용하는 에러
///
/// 데코레이터 패턴을 일부 적용해서 이전에 에러가 발생한 부분을 추적할 수 있도록 만들었습니다.
///
/// 사용법은 아래와 같습니다.
/// ```swift
/// func requestWithStatusCode(router: HTTPRequestable) async throws -> (Int, Data) {
///     throw KEEVError(
///         layer: .utility(of: "NetworkUtility"),
///         caller: "request(router:)",
///         occurPoint: .remote(code: 400, message: "token is invalid"),
///         previousError: nil
///     )
/// }
///
/// func signUp(email: String, nickname: String, profileImage: UIImage?, backgroundImage: UIImage?, description: String) async throws -> SignInStatus {
///     do {
///         let _ = try await requestWithStatusCode(router: AccountHTTPRequestRouter.modifyAccount(accessToken: "123", boundary: "123", multipartData: Data()))
///         return .ok(user: .dummy0)
///     } catch let keevError as KEEVError {
///         throw KEEVError(
///             layer: .service(of: Self.serviceName),
///             caller: "signUp(email:, nickname:, profileImage:, backgroundImage:, description:)",
///             previousKEEVError: keevError
///         )
///     } catch let otherError {
///         throw KEEVError(
///             layer: .service(of: Self.serviceName),
///             caller: "signUp(email:, nickname:, profileImage:, backgroundImage:, description:)",
///             occurPoint: .local(description: "\(otherError)"),
///             previousError: nil
///         )
///     }
/// }
/// ```
///
/// 위에서 던진 에러를 받아서,  `messageForAnalytics`로 출력하면 아래와 같습니다.
/// ```text
/// ----Service: TempAccountService----
///     Occur from signInWithApple(user:, identityToken:, authorizationCode:)-remote.
///
///     code: 400, message: token is invalid
///
/// ----Service: NetworkUtility----
///
///     Occur from request(router:)-remote.
///
///     code: 400, message: token is invalid
///
///     Previous error is nil.
/// ----Last error----
/// ```
///
/// - Author: newJunsung
struct KEEVError: Error {
    /// 에러가 발생한 곳의 레이어 타입
    let layer: LayerType
    /// 에러가 발생한 곳의 함수명
    let caller: String
    /// 발생한 곳의 지점, `.local`, `.remote`, `.custom`이 있습니다.
    let occurPoint: OccurPoint
    /// 이전에 발생한 에러
    let previousError: Error?
    
    init(layer: LayerType, caller: String, occurPoint: OccurPoint, previousError: Error?) {
        self.layer = layer
        self.caller = caller
        self.occurPoint = occurPoint
        self.previousError = previousError
    }
    
    init(layer: LayerType, caller: String, previousKEEVError: KEEVError) {
        self.layer = layer
        self.caller = caller
        self.occurPoint = previousKEEVError.occurPoint
        self.previousError = previousKEEVError
    }
    
    /// 함수를 호출한 부분부터 에러가 발생한 곳까지를 텍스트로 변환하여 반환합니다.
    var messageForAnalytics: String {
        guard let previousError,
              let previousKEEVError = previousError as? KEEVError else {
            return """
        ----Service: \(layer)----
        \tOccur from \(caller)-\(occurPoint.name).
                
        \t\(occurPoint.message)
        
        \t\(previousError == nil ? "Previous error is nil." : "\(previousError!)")
        ----Last error----
        """
        }
        
        
        return """
        ----Service: \(layer)----
        \tOccur from \(caller)-\(occurPoint.name).
                
        \t\(occurPoint.message)
        
        \(previousKEEVError.messageForAnalytics)
        """
    }
}

extension KEEVError {
    /// 에러가 발생한 곳의 위치를 나타내는 열거형
    ///
    /// - Author: newJunsung
    enum OccurPoint {
        /// 디코딩 실패 등의 디바이스 내부에서 발생하는 에러를 처리하는 케이스. `.local(description: "\(error)")`와 같이 사용할 수 있습니다.
        case local(description: String)
        /// 서버로부터 잘못된 응답을 받았을 때 사용하는 케이스. code는 statusCode를 의미하며, message는 서버로부터 받은 메세지를 의미합니다.
        case remote(code: Int, message: String)
        /// 커스텀한 메세지를 보내고 싶을 때 사용하는 케이스
        case custom(message: String)
        
        var name: String {
            switch self {
            case .local:
                "local"
            case .remote:
                "remote"
            case .custom:
                "other"
            }
        }
        
        var message: String {
            switch self {
            case .local(let description):
                "description: \(description)"
            case .remote(let code, let message):
                "code: \(code), message: \(message)"
            case .custom(let message):
                "message: \(message)"
            }
        }
    }
}

extension KEEVError: LocalizedError {
    var errorDescription: String? {
        switch self.occurPoint {
            case .local(let description):
            description
        case .remote(_, let message):
            "\(message)"
        case .custom(let message):
            message
        }
    }
}
