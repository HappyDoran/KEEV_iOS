//
//  ActivityHTTPRequestRouter.swift
//  KEEV
//
//  Created by Yune Cho on 11/27/24.
//

import Foundation

/// 사용자 액티비티에 대한 Router들을 나열한 열거형
///
/// - Author: 라움
enum ActivityHTTPRequestRouter {
    case userInfo(userID: Int)
    case userVibeList(userID: Int)
}

/// HTTPRequestable을 상속받아서 실제로 Request를 할 때 필요한 data, header, method, url을 만듭니다.
///
/// - Author: 라움
extension ActivityHTTPRequestRouter: HTTPRequestable {
    var baseURL: any URLBaseComposable {
        AppEnvironment.keevBaseURL
    }
    
    var body: Data? {
        switch self {
        case .userInfo, .userVibeList: nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .userInfo, .userVibeList:
            return .get
        }
    }
    
    var headers: [String : String]? { nil }
    
    var path: [String]? {
        switch self {
        case .userInfo(let id): ["open-api", "user", "\(id)"]
        case .userVibeList(let id): ["open-api", "user", "\(id)", "vibe"]
        }
    }
    
    var queryItems: [URLQueryItem]? { nil }
}
