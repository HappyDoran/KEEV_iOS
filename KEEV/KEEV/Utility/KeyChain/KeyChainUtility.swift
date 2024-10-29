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
        guard let service = self.service else { return false }
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
    
    func read() -> Data? {
        guard let service = self.service else { return nil }
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
    
    func update() {
        
    }
    
    func delete() {
        
    }
}

