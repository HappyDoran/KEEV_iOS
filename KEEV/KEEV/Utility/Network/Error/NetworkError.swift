//
//  NetworkError.swift
//  KEEV
//
//  Created by Doran on 10/17/24.
//

/// NetworkError에 해당하는 에러를 나열하기 위한 열거형
///
///  서버와의 통신을 할 때 발생하는 에러를 그룹화합니다.
///
/// - Author: Doran
enum NetworkError: Error {
    case badURL
    case invalidResponse(code: Int, message: String)
    case responseConvertFail
    case decodingError
}

extension NetworkError {
    public var errorDescription: String? {
        switch self {
        case .badURL:
            "유효하지 않는 URL 입니다."
            
        case .responseConvertFail:
            "유효하지 않은 응답입니다."
            
        case .decodingError:
            "디코딩에 실패하였습니다."
            
        case .invalidResponse(let code, let message):
            "\(code): \(message)"
        }
    }
}
