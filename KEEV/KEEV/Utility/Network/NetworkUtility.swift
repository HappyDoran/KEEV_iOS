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
    private let decoder = JSONDecoder()
    
    /// URLSession을 Shared Session으로 초기화 하여 기본적인 요청을 하게 하였습니다.
    init(session: URLSession = .shared) {
        self.session = session
    }
    /// 서버에서 데이터를 가져오는 메소드
    ///
    /// - Parameters:
    ///   - router: HTTPRequestable
    ///
    ///  코드의 범용성을 넓히기 위한 제네릭 메소드 구현
    ///
    /// - Throws: 디코딩이 잘못 된 경우 decodingError, URL이 잘못 된 경우 badURL
    /// - Returns: Decodable을 따르는 반환값 ResultType
    ///
    /// - Author: Doran
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
