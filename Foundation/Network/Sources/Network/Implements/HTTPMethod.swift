//
//  HTTPMethod.swift
//  KEEVCore
//
//  Created by junsungkim on 4/28/25.
//

/// HTTP의 Method를 담은 열거형
///
/// ```swift
/// let testURL = URL(string: "https://www.test.com")!
/// var req = URLRequest(url: testURL)
/// req.httpMethod = HTTPMethod.rawValue
/// ```
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
    case delete = "DELETE"
}
