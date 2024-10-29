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
///  - `kSecClass`: 항목의 클래스 ex) 일반 비밀번호
///  - `kSecAttrService`: 서비스 식별자
///  - `kSecAttrAccount`: 계정 식별자 ex) ID
///  - `kSecValueData`: 저장할 데이터 ex) Token
///
/// - Note: 해당 클래스는 shared 를 사용하여 싱글톤으로 구현되어 있습니다.
/// - Author: Doran
final class KeyChainUtility {
    static let shared = KeyChainUtility()
    
    private init() {}
    
    // 추후 사용자의 id로 변경될 수 있습니다.
    private let account = "user"
    
    /// KeyChain에 데이터를 저장하는 함수
    ///
    /// - Parameters:
    ///   - data: 저장할 데이터: `Data`
    ///   - service: 서비스 식별자: `String`
    ///
    ///  키체인 Create의 경우 키값이 중복이 생긴다면, 저장할 수 없기 때문에 먼저 Delete를 해주고 저장합니다. 즉, Update와 동일합니다.
    ///
    /// - Returns: 저장 성공 여부: `Bool`
    ///
    /// - Author: Doran
    @discardableResult
    func create(_ data: Data, service: String) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
    
    /// KeyChain에서 데이터를 읽어오는 함수
    ///
    /// - Parameters:
    ///   - service: 서비스 식별자: `String`
    ///
    /// - Returns: 저장된 데이터 (`Data?`타입). 데이터가 없거나 읽기에 실패한 경우 `nil`을 반환
    ///
    /// - Author: Doran
    func read(service: String) -> Data? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
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
    ///   - service: 서비스 식별자: `String`
    ///
    /// - Author: Doran
    func delete(service: String) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}

