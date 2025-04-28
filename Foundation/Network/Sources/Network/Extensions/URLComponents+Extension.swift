//
//  URLComponents+Extension.swift
//  KEEVCore
//
//  Created by junsungkim on 4/28/25.
//

import Foundation

extension URLComponents {
    mutating func build(from ingredients: some URLComposable) -> URL? {
        if !checkSchemeAndHost(scheme: ingredients.scheme, host: ingredients.host) { return nil }
        
        self.scheme = ingredients.scheme
        self.host = ingredients.host
        self.port = ingredients.port
        
        if let path = ingredients.path {
            self.path = "/" + path.joined(separator: "/")
        } else {
            self.path = ""
        }
        
        self.queryItems = ingredients.queryItems?.map { (name, value) in
            URLQueryItem(name: name, value: value)
        }
        
        return self.url
    }
    
    private func checkSchemeAndHost(scheme: String, host: String) -> Bool {
        guard let _ = scheme.wholeMatch(of: /^[A-Za-z]+$/) else { return false }
        return !(scheme.isEmpty || host.isEmpty)
    }
}
