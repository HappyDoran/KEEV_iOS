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
    /// KOPIS API Key입니다.
    /// KOPIS_API_KEY에 대한 value는 Secret.xcconfig에 저장되어있습니다.
    static let kopisApiKey = Bundle.main.infoDictionary?["KOPIS_API_KEY"] as? String ?? ""
    
    /// KOPIS baseURL입니다.
    static let kopisBaseURL: URL = .init(string: "kopis.or.kr")!
    
    /// UserDefaults에 저장된 바이브들의 배열에 접근하기 위한 key 값입니다.
    static let vibesKey: String = "accessToVibes"
}
