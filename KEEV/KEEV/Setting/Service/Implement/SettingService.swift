//
//  SettingService.swift
//  KEEV
//
//  Created by Yune Cho on 11/11/24.
//

import Foundation
import SwiftUI

class SettingService: SettingServiceProtocol {
    private(set) var version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    
    var notices: [Notice] {
        return [
            Notice(
                title: "[TEST] KEEV 개발중!",
                date: .now,
                content: "KEEV를 세상에 공개하기 위해 열심히 개발하고 있습니다!"
            )
        ]
    }
    
    var termsOfUse: String {
        let filePath = Bundle.main.url(forResource: "TermsOfUse", withExtension: "txt")!
        
        do {
            return try String(contentsOf: filePath, encoding: .utf8)
        } catch {
            return "서비스 이용약관을 불러오는 과정에서 오류가 발생했습니다."
        }
    }
    
    var privacyPolicy: String {
        let filePath = Bundle.main.url(forResource: "PrivacyPolicy", withExtension: "txt")!
        
        do {
            return try String(contentsOf: filePath, encoding: .utf8)
        } catch {
            return "개인정보 처리방침을 불러오는 과정에서 오류가 발생했습니다."
        }
    }
    
    func send(openURL: OpenURLAction) {
        let email = "hmhz.studio@gmail.com"
        let subject = "제목을 입력해주세요."
        let body = "\n\n여러분의 피드백은 더 나은 KEEV 개발에 활용됩니다."
        let urlString = "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
        
        guard let url = URL(string: urlString) else { return }
        openURL(url) { accepted in
            if !accepted {
                print("ERROR: 현재 기기는 이메일을 지원하지 않습니다.")
            }
        }
    }
}
