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
    
    /// KEEV의 현재 버전 정보를 담고 있는 프로퍼티입니다.
    static let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    
    /// KOPIS API Key입니다.
    /// KOPIS_API_KEY에 대한 value는 Secret.xcconfig에 저장되어있습니다.
    static let kopisApiKey = Bundle.main.infoDictionary?["KOPIS_API_KEY"] as? String ?? ""
    
    /// 서버와 통신하는 keevBaseURL입니다.
    static let keevBaseURL: BaseURL = {
        guard let ipAddress = Bundle.main.infoDictionary?["SERVER_IP_ADDRESS"] as? String else {
            fatalError("SERVER_IP_ADDRESS를 찾을 수 없습니다.")
        }
        
        return .init(scheme: "https", host: ipAddress, port: nil)
    }()
    
    /// 앱에서 사용하는 유틸리티와 서비스의 인스턴스를 `DIContainer`에 등록합니다.
    ///
    /// - Important: 유틸리티를 먼저 regist해주시고 서비스를 나중에 regist해주세요!
    ///
    /// - Author: newJunsung
    static func setupDependency() {
        // 주의!: 서비스와 유틸리티의 순서를 뒤바꾸면 앱이 터질 수 있습니다.
        
        // Utility(유틸리티는 해당 구역에 작성해주시면 됩니다.)
        diContainer.register(UIImageCache.init(configuration: .init(countLimit: 0, totalCostLimit: .megabytes(of: 16), cleanTerm: .seconds(of: 0))), for: UIImageCache.self)
        diContainer.register(TokenKeyChainUtility.init(), for: TokenKeyChainUtility.self)
        diContainer.register(NetworkUtility(), for: NetworkUtility.self)
        
        // Service(서비스는 해당 구역에 작성해주시면 됩니다.)
        diContainer.register(AccountService(), for: (any AccountServiceProtocol).self)
        diContainer.register(MockEventService(), for: (any TempEventServiceProtocol).self)
        diContainer.register(SettingService(), for: (any SettingServiceProtocol).self)
        diContainer.register(MockReplyService(), for: (any ReplyServiceProtocol).self)
    }
}
