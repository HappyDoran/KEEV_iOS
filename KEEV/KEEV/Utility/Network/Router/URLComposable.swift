//
//  URLComposable.swift
//  KEEV
//
//  Created by Doran on 10/17/24.
//
import Foundation
/// 프로젝트에서 필요한 scheme(http,https), 호스트, 포트 번호, path, query를 받아서 URL을 구성하는 프로토콜
///
/// - Note: path, queryItems는 optional값이기 때문에 optional 처리를 해줍니다.
/// - Author: Doran
protocol URLComposable {
    var scheme: String { get }
    var host: String { get }
    var port: Int? { get }
    var path: [String]? { get }
    var queryItems: [URLQueryItem]? { get }
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
extension URLComposable {
    func configureURL() throws -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.port = port
        
        // MARK: /consert/detail 처럼 path가 여러개일 경우에 이를 붙이기 위함
        if let path = path {
            components.path = "/\(path.joined(separator: "/"))"
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw NetworkError.badURL
        }
        
        return url
        
    }
}
