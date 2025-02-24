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
    /// KEEV 공지사항 배열을 저장하는 상수입니다.
    let notices: [Notice] = [
        Notice(
            title: "KEEV가 출시되었습니다",
            date: "25.01.15".toDate(format: "yy.MM.dd") ?? .now,
            content: """
            안녕하세요 공연 러버 여러분, 
            "매일 열리는 공연 뒷풀이" KEEV가 출시되었습니다.
            
            주요 기능
            
            공연 정보
            “흩어진 공연 정보를 한 곳에서, 모든 공연 정보를 한눈에“
            해외 아티스트 내한 공연부터 국내 인디 공연까지 다양한 정보를 제공합니다. 장르와 기간별로 원하는 공연을 손쉽게 찾아보는 건 물론, 시즌별 추천 공연으로 다양한 공연을 발견할 수 있어요.
            
            공연 기록
            "공연의 여운과 본 공연 내역을 내 바이브로 손쉽게”
            공연 후의 여운을 잊거나, 언제 어떤 공연을 봤는지 까먹은 적 있으신가요? 키브에서 공연 후 느낀 여운을 ‘바이브’로 기록해 간편하게 정리하고, 지금까지 관람한 공연을 한눈에 확인해 보세요.
            
            커뮤니티
            “방금 보고온 그 공연, 다른 사람들은 어떻게 느꼈을까?”
            공연의 바이브를 공유하며 내가 놓친 다른 관객들의 시선을 확인하고, 공연에 대한 감상을 함께 나눠보세요. 나와 공연 취향이 비슷한 친구를 발견할지도 몰라요.
            
            업데이트 예정 기능
            
            관심공연
            관심 공연을 등록해 "갈 예정인 공연"을 프로필에 표시하고 공연일, 예매일 등의 알림을 받을 수 있어요.
            
            좋아요
            맘에 드는 바이브와 댓글에 "좋아요"를 남길 수 있어요.
            
            유저 팔로우, 팔로잉
            맘에 드는 바이브를 남긴 유저의 프로필을 확인하고 팔로우를 할 수 있어요.
            """
        ),
        
        Notice(
            title: "1.1.0 업데이트 공지사항",
            date: "25.02.25".toDate(format: "yy.MM.dd") ?? .now,
            content:
"""
더욱 편리하게 공연을 탐색하고 기록할 수 있도록 새로운 기능을 추가했어요. 이번 업데이트에에 추가된 기능들을 확인해 보세요!

-피드

피드 탭에서 최신 공연 후기를 한눈에 볼 수 있어요. KEEV에 올라온 다양한 공연 후기를 최신순으로 빠르게 확인해 보세요.

-관심 공연 저장

가고 싶은 공연을 쉽게 관리할 수 있도록 관심 공연 기능이 추가되었어요. 공연 정보에서 ‘관심’ 버튼을 누르면 프로필에서 저장된 공연을 한눈에 확인할 수 있어요. 놓치고 싶지 않은 공연이 있다면 관심 버튼을 눌러 보세요!

-좋아요!

이제 바이브와 댓글에 좋아요를 남길 수 있어요. 공감 가는 공연 기록에 좋아요를 눌러 함께 공연의 여운을 나눠 보세요.
"""
        )
    ]
    
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
        openURL.callAsFunction(url)
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
    
    /// 서비스 이용약관을 리턴하는 함수
    ///
    /// 서비스 이용약관을 리턴하는 함수입니다.
    ///
    /// - Returns: Resource/Document에 위치한 TermsOfUse.txt 파일로부터 서비스 이용약관을 가져와서 리턴하고 불러오는데 실패할 경우 오류문구를 리턴합니다.
    ///
    /// - Author: 라움
    func termsOfUse() -> String {
        let filePath = Bundle.main.url(forResource: "TermsOfUse", withExtension: "txt")!
        
        do {
            return try String(contentsOf: filePath, encoding: .utf8)
        } catch {
            return "서비스 이용약관을 불러오는 과정에서 오류가 발생했습니다."
        }
    }
    
    /// 개인정보 처리방침을 리턴하는 함수
    ///
    /// 개인정보 처리방침을 리턴하는 함수입니다.
    ///
    /// - Returns: Resource/Document에 위치한 PrivacyPolicy.txt 파일로부터 개인정보 처리방침을 가져와서 리턴하고 불러오는데 실패할 경우 오류문구를 리턴합니다.
    ///
    /// - Author: 라움
    func privacyPolicy() -> String {
        let filePath = Bundle.main.url(forResource: "PrivacyPolicy", withExtension: "txt")!
        
        do {
            return try String(contentsOf: filePath, encoding: .utf8)
        } catch {
            return "개인정보 처리방침을 불러오는 과정에서 오류가 발생했습니다."
        }
    }
}
