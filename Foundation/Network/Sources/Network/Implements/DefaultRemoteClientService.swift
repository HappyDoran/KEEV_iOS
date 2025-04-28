//
//  DefaultRemoteClientService.swift
//  KEEVCore
//
//  Created by junsungkim on 4/28/25.
//

import Foundation

public final class DefaultRemoteClientService: RemoteClientService {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    public func request<T>(
        from converter: some URLRequestConvertible,
        for type: T.Type,
        decoder: JSONDecoder = .init()
    ) async throws -> T where T : Decodable {
        let request = try buildRequest(from: converter)
        let (data, _) = try await session.data(for: request)
        return try decoder.decode(T.self, from: data)
    }
    
    public func request(from converter: some URLRequestConvertible) async throws -> APIResponse {
        let request = try buildRequest(from: converter)
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw URLError(.cannotParseResponse)
        }
        
        return (data, response.statusCode)
    }
    
    private func buildRequest(from converter: URLRequestConvertible) throws -> URLRequest {
        var components = URLComponents()
        
        guard let url = components.build(from: converter.urlIngredients) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = converter.method.rawValue
        request.allHTTPHeaderFields = converter.headers
        request.httpBody = try converter.body.toData()
        return request
    }
}
