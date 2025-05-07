//
//  URLComponents+Extension.swift
//  KEEVCore
//
//  Created by junsungkim on 4/28/25.
//

import Foundation

extension URLComponents {
    /// URLComposable로 URL을 만드는 함수
    /// URLComposable의 프로퍼티를 URLComponent에 주입하여 URL을 만듭니다.
    ///
    /// 몇 가지 상황에서 URL을 반환하지 않고 nil을 반환합니다.
    /// 1. scheme에 아무런 텍스트가 들어가지 않았거나, 알파벳(특수문자, 한글 등)이 아닌 글자가 들어가 있을 때
    /// 2. host에 아무런 텍스트가 들어가지 않았을 때.
    ///
    /// - Returns: 조건을 만족하면 URL, 만족하지 않으면 nil
    /// - Author: 뉴준성
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
    
    /// 스킴과 호스트를 체크하는 함수
    private func checkSchemeAndHost(scheme: String, host: String) -> Bool {
        guard let _ = scheme.wholeMatch(of: /^[A-Za-z]+$/) else { return false }
        return !(scheme.isEmpty || host.isEmpty)
    }
}
