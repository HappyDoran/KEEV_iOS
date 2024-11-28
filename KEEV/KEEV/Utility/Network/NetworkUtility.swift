//
//  NetworkUtility.swift
//  KEEV
//
//  Created by Doran on 10/17/24.
//

import Foundation
/// 서버와의 통신을 실질적으로 수행하는 메소드를 가진 구조체
///
/// - Author:   Doran
struct NetworkUtility {
    private let session: URLSession
    
    /// URLSession을 Shared Session으로 초기화 하여 기본적인 요청을 하게 하였습니다.
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// 서버에서 데이터를 가져오는 메소드
    ///
    /// - Parameters:
    ///   - router: HTTPRequestable
    ///
    ///  요청을 보내서 서버로부터 가져온 데이터를 리턴하는 메소드입니다.
    ///
    /// - Throws: URL이 잘못 된 경우 badURL
    /// - Returns: 서버로부터 가져온 데이터
    ///
    /// - Author: Doran, 라움
    func request(router: HTTPRequestable) async throws -> Data {
        let request = try router.asURLRequest()
        
        let (data, _) = try await session.data(for: request)
        
        return data
    }
    
    /// MultipartForm으로 데이터를 요청하고 서버에서 데이터를 가져오는 메소드
    ///
    /// - Parameters:
    ///   - router: HTTPRequestable
    ///   - boundary: MultipartForm에서의 바운더리 값
    ///
    ///  MultipartForm으로 요청을 보내서 서버로부터 가져온 데이터를 리턴하는 메소드입니다.
    ///
    /// - Throws: URL이 잘못 된 경우 badURL
    /// - Returns: 서버로부터 가져온 데이터
    ///
    /// - Author: 라움
    func requestWithMultipartForm(router: HTTPRequestable, boundary: String) async throws -> Data {
        var request = try router.asURLRequest()
        request.setValue("multipart/form-data; boundary=\"\(boundary)\"", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await session.data(for: request)
        
        return data
    }
    
    /// 서버에서 데이터를 가져오는 메소드
    ///
    /// - Parameters:
    ///   - router: HTTPRequestable
    ///
    ///  요청을 보내서 서버로부터 가져온 데이터를 status code와 함께 튜플로 리턴하는 메소드입니다.
    ///
    /// - Throws: URL이 잘못 된 경우 badURL
    /// - Returns: 서버로 가져온 status code와 데이터의 튜플
    ///
    /// - Author: 라움
    func requestWithStatusCode(router: HTTPRequestable) async throws -> (Int, Data) {
        let request = try router.asURLRequest()
        
        print("Request URL: \(request.url?.absoluteString ?? "Invalid URL")")
        
        let (data, response) = try await session.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NSError(domain: "ServerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Server Error"])
        }
        
        return (statusCode, data)
    }
    
    /// API 통신시 XML 데이터를 가져오기 위한 메소드
    ///
    /// - Parameters:
    ///   - router: HTTPRequestable
    ///
    ///  - Throws: Response가 실패할 경우 ServerError, URL이 잘못 된 경우 badURL
    /// - Returns: XMLData를 담은 Data
    ///
    /// - Author: Doran
    func xmlRequest(router: HTTPRequestable) async throws -> Data {
        let request = try router.asURLRequest()
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "ServerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Server Error"])
        }
        
        return data
    }
}
