//
//  DefaultRemoteClientService.swift
//  KEEVCore
//
//  Created by junsungkim on 4/28/25.
//

import Foundation

/// RemoteClientService를 채택해서 만든 기본 서버 통신 객체
public final class DefaultRemoteClientService: RemoteClientService {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    /// URLRequestConvertible를 채택한 타입을 받아 데이터를 지정한 타입으로 디코딩하여 반환하는 함수
    ///
    /// 인자로 받은 JSONDecoder를 활용하여 디코딩을 합니다.
    /// 이 때, JSONDecoder로 인자로 넣지 않을 경우, 기본 생성자가 들어갑니다.
    /// 디코딩이 실패하면 DecodingError를 발생시킵니다.
    public func request<T>(
        by converter: some URLRequestConvertible,
        for type: T.Type,
        decoder: JSONDecoder = .init()
    ) async throws -> T where T : Decodable {
        let request = try converter.buildRequest()
        let (data, _) = try await session.data(for: request)
        return try decoder.decode(T.self, from: data)
    }
    
    /// URLRequestConvertible를 채택한 타입을 받아 (Data, Int)를 반환하는 함수
    ///
    /// Data의 경우 서버로부터 받은 body에 있는 데이터입니다.
    /// Int의 경우 StatusCode를 입니다.
    /// HTTP를 통해 통신한 것이 아닐 경우, URLError(.cannotParseResponse) 에러를 던집니다.
    public func request(by converter: some URLRequestConvertible) async throws -> APIResponse {
        let request = try converter.buildRequest()
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw URLError(.cannotParseResponse)
        }
        
        return (data, response.statusCode)
    }
    
    /// URLRequest를 받아 데이터를 지정한 타입으로 디코딩하여 반환하는 함수
    ///
    /// 인자로 받은 JSONDecoder를 활용하여 디코딩을 합니다.
    /// 이 때, JSONDecoder로 인자로 넣지 않을 경우, 기본 생성자가 들어갑니다.
    /// 디코딩이 실패하면 DecodingError를 발생시킵니다.
    public func request<T>(
        from request: URLRequest,
        for type: T.Type,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T where T : Decodable {
        let (data, _) = try await session.data(for: request)
        return try decoder.decode(T.self, from: data)
    }
    
    /// URLRequest를 받아 (Data, Int)를 반환하는 함수
    ///
    /// Data의 경우 서버로부터 받은 body에 있는 데이터입니다.
    /// Int의 경우 StatusCode를 입니다.
    /// HTTP를 통해 통신한 것이 아닐 경우, URLError(.cannotParseResponse) 에러를 던집니다.
    public func request(from request: URLRequest) async throws -> APIResponse {
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw URLError(.cannotParseResponse)
        }
        
        return (data, response.statusCode)
    }
}
