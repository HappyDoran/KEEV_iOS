//
//  URLComponents+Extension.swift
//  KEEVCore
//
//  Created by junsungkim on 4/28/25.
//

import Foundation

extension URLComponents {
    mutating func build(from ingredients: some URLComposable) -> URL? {
        self.scheme = ingredients.scheme
        self.host = ingredients.host
        self.port = ingredients.port
        self.path = "/" + (ingredients.path?.joined(separator: "/") ?? "")
        self.queryItems = ingredients.queryItems?.map { (name, value) in
            URLQueryItem(name: name, value: value)
        }
        
        return self.url
    }
    
    mutating func build(url: some BaseURL, with endpoint: some URLEndpoint) -> URL? {
        self.scheme = url.scheme
        self.host = url.host
        self.port = url.port
        self.path = endpoint.path?.joined(separator: "/") ?? ""
        self.queryItems = endpoint.queryItems?.map { (name, value) in
            URLQueryItem(name: name, value: value)
        }
        
        return self.url
    }
}
