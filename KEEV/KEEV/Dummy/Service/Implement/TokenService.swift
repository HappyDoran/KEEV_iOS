//
//  TokenService.swift
//  KEEV
//
//  Created by Doran on 10/29/24.
//
import SwiftUI

class TokenService: TokenServiceProtocol {
    @Published var accessToken = ""
    @Published var refreshToken = ""
    @Published var retrievedAccessToken = ""
    @Published var retrievedRefreshToken = ""
    
    
    func save() {
        if let accessData = accessToken.data(using: .utf8),
           let refreshData = refreshToken.data(using: .utf8) {
            
            KeyChainUtility.shared.create(accessData, service: "access-token")
            KeyChainUtility.shared.create(refreshData, service: "refresh-token")
            
            print("Tokens saved successfully.")
        }
    }
    
    func load() {
        if let accessData = KeyChainUtility.shared.read(service: "access-token"),
           let accessText = String(data: accessData, encoding: .utf8) {
            retrievedAccessToken = accessText
        } else {
            retrievedAccessToken = "No access token found."
        }
        
        if let refreshData = KeyChainUtility.shared.read(service: "refresh-token"),
           let refreshText = String(data: refreshData, encoding: .utf8) {
            retrievedRefreshToken = refreshText
        } else {
            retrievedRefreshToken = "No refresh token found."
        }
    }
    
    func delete() {
        KeyChainUtility.shared.delete(service: "access-token")
        KeyChainUtility.shared.delete(service: "refresh-token")
        
        print("Tokens deleted.")
        
        retrievedAccessToken = ""
        retrievedRefreshToken = ""
    }
}
