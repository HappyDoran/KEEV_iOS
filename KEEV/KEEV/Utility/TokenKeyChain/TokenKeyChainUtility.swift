//
//  KeyChainUtility.swift
//  KEEV
//
//  Created by Doran on 10/29/24.
//

import Foundation
import Security

/// KeyChain에서 CRUD를 사용하기 위한 Utility
///
/// KeyChain의 생성, 읽기, 삭제가 구현 되어있습니다.
///
/// KeyChain의 아이템에는 다음과 같은 속성이 포함됩니다:
///  - `kSecClass`:  키체인 데이터 종류
///  - `kSecAttrApplicationTag`:  키체인 항목에 태그 (항목 식별)
///  - `kSecAttrApplicationLabel`:  사용자 정의 라벨 ex) 번들러 아이디
///  - `kSecValueData`:  저장할 데이터 ex) Token
///
/// - Note: 해당 클래스는 shared 를 사용하여 싱글톤으로 구현되어 있습니다.
/// - Author: Doran
final class TokenKeyChainUtility {
    private static let applicationLabel = Bundle.main.bundleIdentifier ?? "com.HMHZ.KEEV"
    
    /// KeyChain에 데이터를 저장하는 함수
    ///
    /// - Parameters:
    ///   - token: 저장할 토큰: `String`
    ///   - tokenTag: 어떠한 종류의 토큰 타입 : `String`
    ///
    /// 키체인 Create의 경우 키값이 중복이 생긴다면, 저장할 수 없기 때문에 먼저 Delete를 해주고 저장합니다. 즉, Update와 동일합니다.
    ///
    /// - Returns: 저장 성공 여부: `Bool`
    /// - Throws: 작업 실패 시 `KeyChainError`
    ///
    /// - Author: Doran
    func create(_ token: String, tokenTag: String) throws {
        guard let tokenData = token.data(using: .utf8) else {
            throw TokenKeyChainError.invalidToken
        }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: tokenTag,
            kSecAttrApplicationLabel: TokenKeyChainUtility.applicationLabel,
            kSecValueData: tokenData
        ]
        
        SecItemDelete(query as CFDictionary)
        
        if SecItemAdd(query as CFDictionary, nil) != errSecSuccess {
            throw TokenKeyChainError.AddFailed
        }
    }
    
    /// KeyChain에서 데이터를 읽어오는 함수
    ///
    /// - Parameters:
    ///   - tokenTag: 어떠한 종류의 토큰 타입 : `String`
    ///
    /// - Returns: 저장된 데이터 (`Data?`타입). 데이터가 없거나 읽기에 실패한 경우 `nil`을 반환
    ///
    /// - Author: Doran
    func read(tokenTag: String) -> Data? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: tokenTag,
            kSecAttrApplicationLabel: TokenKeyChainUtility.applicationLabel,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        
        if SecItemCopyMatching(query as CFDictionary, &dataTypeRef) == errSecSuccess {
            return dataTypeRef as? Data
        }
        
        return nil
    }
    
    /// KeyChain에서 데이터를 삭제하는 함수
    ///
    /// - Parameters:
    ///   - tokenTag: 토큰과 연관된 태그 (`String`)
    ///
    /// - Throws: 삭제 실패 시 `KeyChainError`
    ///
    /// - Author: Doran
    func delete(tokenTag: String) throws {
        let query: [CFString: Any] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: tokenTag,
            kSecAttrApplicationLabel: TokenKeyChainUtility.applicationLabel,
        ]
        
        if SecItemDelete(query as CFDictionary) != errSecSuccess {
            throw TokenKeyChainError.DeleteFailed
        }
    }
}

