//
//  NetworkUtility.swift
//  KEEV
//
//  Created by Doran on 10/17/24.
//

import Foundation

struct NetworkUtility {
    private let session: URLSession
    private let decoder = JSONDecoder()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<ResultType: Decodable>(router: HTTPRequestable) async throws -> ResultType {
        let request = try router.asURLRequest()
        let (data, response) = try await session.data(for: request)
        
        print(data)
        
        guard let decodedData = try? decoder.decode(ResultType.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return decodedData
    }
}
