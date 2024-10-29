//
//  KeyChainUtility.swift
//  KEEV
//
//  Created by Doran on 10/29/24.
//

import Foundation
import Security

final class KeyChainUtility {
    static let shared = KeyChainUtility()
    
    private init() {}
    private let service = Bundle.main.bundleIdentifier
    private let account = "KEEV"
    
    func create(_ data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as Any,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
    
    func read() -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as Any,
            kSecAttrAccount as String: account,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        
        if SecItemCopyMatching(query as CFDictionary, &dataTypeRef) == errSecSuccess {
            return dataTypeRef as? Data
        }
        
        return nil
    }
    
    func update() {
        
    }
    
    func delete() {
        
    }
}
