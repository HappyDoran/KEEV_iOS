//
//  TokenService.swift
//  KEEV
//
//  Created by Doran on 10/29/24.
//
import SwiftUI

/// TokenService는 사용자의 accessToken과 refreshToken을 키체인에 저장, 불러오기, 삭제를 하는 비즈니스 로직을 구현한 클래스
///
/// - Note: 현재는 View에서 accessToken과 refreshToken을 가장한 String을 받아서 저장을 하고 있습니다. 때문에 추후에 서버에서 response 해온 Token을 가져온다면 추가적으로 jsonDecoder, jsonEncoder를 구현할 예정입니다.
///
/// - Author: Doran
class TokenService: TokenServiceProtocol {
    
    /// 이부분도 어차피 View에서 보여주지 않을 내용이기 때문에 서버 연결 이후에 @Published를 삭제하고 private로 수정할 예정입니다.
    @Published var accessToken = ""
    @Published var refreshToken = ""
    @Published var retrievedAccessToken = ""
    @Published var retrievedRefreshToken = ""
    
    /// 사용자의  accessToken과 refreshToken을 키체인에 저장.
    ///
    /// - Note: 이 메서드는 현재 String 타입의 토큰을 저장하고 있습니다. 추후 JSON 데이터를 처리할 수 있도록 개선될 예정입니다.
    ///
    /// - Author: Doran
    func save() {
        if let accessData = accessToken.data(using: .utf8),
           let refreshData = refreshToken.data(using: .utf8) {
            
            KeyChainUtility.shared.create(accessData, service: "accessToken")
            KeyChainUtility.shared.create(refreshData, service: "refreshToken")
            
        }
    }
    
    /// 키체인에서 사용자의  accessToken과 refreshToken을 불러옴.
    ///
    /// - Note: 불러온 토큰은 `retrievedAccessToken`과 `retrievedRefreshToken`에 저장.
    ///
    /// - Author: Doran
    func load() {
        if let accessData = KeyChainUtility.shared.read(service: "accessToken"),
           let accessText = String(data: accessData, encoding: .utf8) {
            retrievedAccessToken = accessText
        } else {
            retrievedAccessToken = "No access token found."
        }
        
        if let refreshData = KeyChainUtility.shared.read(service: "refreshToken"),
           let refreshText = String(data: refreshData, encoding: .utf8) {
            retrievedRefreshToken = refreshText
        } else {
            retrievedRefreshToken = "No refresh token found."
        }
    }
    
    /// 키체인에서 사용자의  accessToken과 refreshToken을 삭제.
    ///
    /// - Note: 삭제 후에는 `retrievedAccessToken`과 `retrievedRefreshToken`이 빈 문자열로 설정.
    ///
    /// - Author: Doran
    func delete() {
        KeyChainUtility.shared.delete(service: "accessToken")
        KeyChainUtility.shared.delete(service: "refreshToken")
        
        retrievedAccessToken = ""
        retrievedRefreshToken = ""
    }
}
