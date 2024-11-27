//
//  URLBaseComposable.swift
//  KEEV
//
//  Created by Yune Cho on 11/14/24.
//

import Foundation

/// 프로젝트에서 필요한 scheme(http,https), 호스트, 포트 번호를 받아서 URL을 구성하는 프로토콜
///
/// - Author: 라움
protocol URLBaseComposable {
    var scheme: String { get }
    var host: String { get }
    var path: [String]? { get }
    var port: Int? { get }
    
    /// URL을 만드는 메소드
    ///
    ///  읽기, 쓰기가 가능한 URLComponents를 사용하여 URL을 구성합니다.
    ///
    /// - Throws: URL이 잘못됐음을 알려주는 Error
    /// - Returns: 완성된 URL
    ///
    /// - Author: Doran
    func configureURL() throws -> URL
}

extension URLBaseComposable {
    func configureURL() throws -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.port = port
        
        if let path = path {
            components.path = "/\(path.joined(separator: "/"))"
        }
        
        guard let url = components.url else {
            throw NetworkError.badURL
        }
        
        return url
    }
}
