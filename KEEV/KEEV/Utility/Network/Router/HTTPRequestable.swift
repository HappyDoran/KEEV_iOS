//
//  HTTPRequestable.swift
//  KEEV
//
//  Created by Doran on 10/17/24.
//

import Foundation

/// Request를 하는 프로토콜
///
/// URL, header, body를 동봉하여 선택한 method 방식으로 request 한다.
///
/// - Note: URLComposable 프로토콜을 상속하여 asURL() function을 사용하여 URL을 만들 수 있다.
/// - Author: Doran
protocol HTTPRequestable: URLComposable {
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    
    /// URL을 토대로 request 실행하는 함수
    ///
    /// - Throws: URL이 잘못됐음을 알려주는 Error
    /// - Returns: request
    ///
    /// - Author: Doran
    func asURLRequest() throws -> URLRequest
}

extension HTTPRequestable {
    var scheme: String { "https" }
    
    func asURLRequest() throws -> URLRequest {
        let url = try configureURL()
        
        var request = URLRequest(url: url)
        request.httpMethod = "\(method)"
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        return request
    }
}
