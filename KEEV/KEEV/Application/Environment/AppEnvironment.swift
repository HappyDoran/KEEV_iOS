//
//  AppEnvironment.swift
//  KEEV
//
//  Created by Yune Cho on 10/17/24.
//

import Foundation

/// 앱의 환경변수들을 저장하고 있는 구조체
///
/// 앱의 환경변수들을 전역변수로 저장하고 있습니다.
///
/// - Author: 라움
struct AppEnvironment {
    static let diContainer: DIContainer = .init()
    
    /// KOPIS API Key입니다.
    /// KOPIS_API_KEY에 대한 value는 Secret.xcconfig에 저장되어있습니다.
    static let kopisApiKey = Bundle.main.infoDictionary?["KOPIS_API_KEY"] as? String ?? ""
    
    /// KOPIS baseURL입니다.
    static let kopisBaseURL: URL = .init(string: "kopis.or.kr")!
    
    static func setupDependency() {
        diContainer.register(UIImageCache.init(configuration: .init(countLimit: 0, totalCostLimit: .megabytes(of: 16), cleanTerm: .seconds(of: 0))), for: UIImageCache.self)
        diContainer.register(TokenKeyChainUtility.init(), for: TokenKeyChainUtility.self)
        diContainer.register(NetworkUtility(), for: NetworkUtility.self)
        
        diContainer.register(AccountService(), for: (any AccountServiceProtocol).self)
        diContainer.register(EventService(), for: (any EventServiceProtocol).self)
    }
}
