//
//  SettingService.swift
//  KEEV
//
//  Created by Yune Cho on 11/11/24.
//

import Foundation
import SwiftUI

/// Setting 화면과 관련된 데이터와 기능을 제공하는 Sevice
///
/// Setting 화면과 관련된 데이터와 기능을 제공하는 Sevice입니다.
///
/// - Author: 라움
class SettingService: SettingServiceProtocol {
    /// KEEV의 현재 버전 정보를 담고 있는 프로퍼티입니다.
    private(set) var version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    
    /// KEEV 공지사항 배열을 리턴하는 연산 프로퍼티입니다.
    var notices: [Notice] {
        return [
            Notice(
                title: "[TEST] KEEV 개발중!",
                date: .now,
                content: "KEEV를 세상에 공개하기 위해 열심히 개발하고 있습니다!"
            )
        ]
    }
    
    /// 서비스 이용약관을 리턴하는 연산 프로퍼티
    ///
    /// 서비스 이용약관을 리턴하는 연산 프로퍼티입니다.
    ///
    /// Resource/Document에 위치한 TermsOfUse.txt 파일로부터 서비스 이용약관을 가져와서 리턴하고 불러오는데 실패할 경우 오류문구를 리턴합니다.
    ///
    /// - Author: 라움
    var termsOfUse: String {
        let filePath = Bundle.main.url(forResource: "TermsOfUse", withExtension: "txt")!
        
        do {
            return try String(contentsOf: filePath, encoding: .utf8)
        } catch {
            return "서비스 이용약관을 불러오는 과정에서 오류가 발생했습니다."
        }
    }
    
    /// 개인정보 처리방침을 리턴하는 연산 프로퍼티
    ///
    /// 개인정보 처리방침을 리턴하는 연산 프로퍼티입니다.
    ///
    /// Resource/Document에 위치한 PrivacyPolicy.txt 파일로부터 개인정보 처리방침을 가져와서 리턴하고 불러오는데 실패할 경우 오류문구를 리턴합니다.
    ///
    /// - Author: 라움
    var privacyPolicy: String {
        let filePath = Bundle.main.url(forResource: "PrivacyPolicy", withExtension: "txt")!
        
        do {
            return try String(contentsOf: filePath, encoding: .utf8)
        } catch {
            return "개인정보 처리방침을 불러오는 과정에서 오류가 발생했습니다."
        }
    }
    
    /// 애플 기본 메일 앱의 메일 전송화면으로 연결해주는 함수
    ///
    /// - Parameters:
    ///   - openURL: URL을 열 수 있는 Environment 변수
    ///
    /// 피드백 및 문의사항을 보낼 수 있는 애플 기본 메일 앱의 메일 전송화면으로 연결해주는 함수입니다.
    ///
    /// - Author: 라움
    func send(openURL: OpenURLAction) {
        let feedbackEmail = FeedbackEmail()
        let urlString = "mailto:\(feedbackEmail.email)?subject=\(feedbackEmail.subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(feedbackEmail.body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
        
        guard let url = URL(string: urlString) else { return }
        openURL(url) { accepted in
            if !accepted {
                print("ERROR: 현재 기기는 이메일을 지원하지 않습니다.")
            }
        }
    }
    
    /// 피드백 및 문의사항을 보내기 위한 이메일 주소와 템플릿
    ///
    /// 피드백 및 문의사항을 보내기 위한 이메일 주소와 템플릿입니다.
    ///
    /// - Author: 라움
    private struct FeedbackEmail {
        let email = "hmhz.studio@gmail.com"
        let subject = "제목을 입력해주세요."
        let body = "\n\n여러분의 피드백은 더 나은 KEEV 개발에 활용됩니다."
    }
}
