//
//  NetworkUtility.swift
//  KEEV
//
//  Created by Doran on 10/17/24.
//

import Foundation
import Network
/// 서버와의 통신을 실질적으로 수행하는 메소드를 가진 구조체
///
/// - Author: Doran
struct NetworkUtility {
    private let service = DefaultRemoteClientService()
    private let decoder: JSONDecoder = JSONDecoder()
    
    /// 서버에서 데이터를 가져오는 메소드
    ///
    /// - Parameters:
    ///   - router: HTTPRequestable
    ///
    ///  요청을 보내서 서버로부터 가져온 데이터를 리턴하는 메소드입니다.
    ///
    /// - Throws: URL이 잘못되거나 StatusCode가 200대가 아닐 경우 경우 KEEVError
    /// - Returns: 서버로부터 가져온 데이터
    ///
    /// - Author: Doran, 라움
    func request(router: any HTTPRequestable) async throws -> Data {
        let request = try router.asURLRequest()
        
        let (data, _) = try await fetchData(from: request)
        
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
    /// - Throws: URL이 잘못되거나 StatusCode가 200대가 아닐 경우 경우 KEEVError
    /// - Returns: 서버로부터 가져온 데이터
    ///
    /// - Author: 라움
    func requestWithMultipartForm(router: HTTPRequestable, boundary: String) async throws -> Data {
        var request = try router.asURLRequest()
        request.setValue("multipart/form-data; boundary=\"\(boundary)\"", forHTTPHeaderField: "Content-Type")
        
        let (data, statusCode) = try await fetchData(from: request)
        
        guard (200..<300).contains(statusCode) else {
            let errorMessage = try decodeErrorMessage(from: data)
            
            throw URLError(.badServerResponse)
        }
        
        return data
    }
    
    /// 서버에서 데이터를 가져오는 메소드
    ///
    /// - Parameters:
    ///   - router: HTTPRequestable
    ///
    ///  요청을 보내서 서버로부터 가져온 데이터를 status code와 함께 튜플로 리턴하는 메소드입니다.
    ///
    /// - Throws: URL이 잘못되거나 StatusCode가 200대가 아닐 경우 경우 KEEVError
    /// - Returns: 서버로 가져온 status code와 데이터의 튜플
    ///
    /// - Author: 라움
    func requestWithStatusCode(router: HTTPRequestable) async throws -> (Int, Data) {
        let request = try router.asURLRequest()
        
        let (data, statusCode) = try await fetchData(from: request)
        
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
        
        let (data, _) = try await fetchData(from: request)
        
        return data
    }
    
    private func fetchData(from request: URLRequest) async throws -> (Data, Int) {
        let (data, statusCode) = try await service.request(from: request)
            
        return (data, statusCode)
    }
    
    private func decodeErrorMessage(from data: Data) throws -> ErrorMessageDTO {
        try decoder.decode(ErrorMessageDTO.self, from: data)
    }
}
