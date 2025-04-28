//
//  URLComposableMock.swift
//  Network
//
//  Created by junsungkim on 4/28/25.
//

import Foundation

struct URLComposableMock: URLComposable {
    static let mockScheme = "https"
    static let mockHost = "mock-host.com"
    
    let scheme: String
    let host: String
    let port: Int?
    let path: [String]?
    let queryItems: [String : String]?
    
    init(scheme: String = Self.mockScheme, host: String = Self.mockHost, port: Int?, path: [String]?, queryItems: [String : String]?) {
        self.scheme = scheme
        self.host = host
        self.port = port
        self.path = path
        self.queryItems = queryItems
    }
}

extension URLComposableMock {
    // MARK: 테스트 데이터
    /// 스킴과 호스트만 제대로 들어갔을 때
    static let test0 = URLComposableMock(port: nil, path: nil, queryItems: nil)
    /// 스킴과 호스트가 제대로 들어가고, 쿼리만 들어갔을 때
    static let test1 = URLComposableMock(port: nil, path: nil, queryItems: ["key": "value"])
    /// 스킴과 호스트가 제대로 들어가고, 패스만 들어갔을 때
    static let test2 = URLComposableMock(port: nil, path: ["path"], queryItems: nil)
    /// 스킴과 호스트가 제대로 들어가고, 패스와 쿼리가 들어갔을 때
    static let test3 = URLComposableMock(port: nil, path: ["path"], queryItems: ["key1": "value1", "key2": "value2"])
    /// 스킴과 호스트가 제대로 들어가고, 포트만 들어갔을 때
    static let test4 = URLComposableMock(port: 8080, path: nil, queryItems: nil)
    /// 스킴과 호스트가 제대로 들어가고, 포트와 쿼리가 들어갔을 때
    static let test5 = URLComposableMock(port: 8080, path: nil, queryItems: ["key1": "value1", "key2": "value2"])
    /// 스킴과 호스트가 제대로 들어가고, 포트와 패스가 들어갔을 때
    static let test6 = URLComposableMock(port: 8080, path: ["path"], queryItems: nil)
    /// 스킴과 호스트가 제대로 들어가고, 포트와 패스, 쿼리가 모두 들어갔을 때
    static let test7 = URLComposableMock(port: 8080, path: ["path"], queryItems: ["key": "value"])
    /// 잘못된 스킴이 들어갔을 때
    static let test8 = URLComposableMock(scheme: "https://", port: nil, path: nil, queryItems: nil)
    /// 잘못된 스킴이 들어가고 호스트가 없을 때
    static let test9 = URLComposableMock(scheme: "https", host: "", port: nil, path: nil, queryItems: nil)
    /// 스킴과 호스트, 포트, 패스, 쿼리 모두에 아무 것도 들어가지 않았을 때
    static let test10 = URLComposableMock(scheme: "", host: "",  port: nil, path: nil, queryItems: nil)
    
    // MARK: 검사용 데이터
    /// test 0의 예상 결과
    static let result0: URL? = URL(string: "\(Self.mockScheme)://\(Self.mockHost)")
    /// test 1의 예상 결과
    static let result1: URL? = URL(string: "\(Self.mockScheme)://\(Self.mockHost)?key=value")
    /// test 2의 예상 결과
    static let result2: URL? = URL(string: "\(Self.mockScheme)://\(Self.mockHost)/path")
    /// test 3의 예상 결과
    static let result3: URL? = URL(string: "\(Self.mockScheme)://\(Self.mockHost)/path/?key1=value1&key2=value2")
    /// test 4의 예상 결과
    static let result4: URL? = URL(string: "\(Self.mockScheme)://\(Self.mockHost):8080")
    /// test 5의 예상 결과
    static let result5: URL? = URL(string: "\(Self.mockScheme)://\(Self.mockHost):8080?key1=value1&key2=value2")
    /// test 6의 예상 결과
    static let result6: URL? = URL(string: "\(Self.mockScheme)://\(Self.mockHost):8080/path")
    /// test 7의 예상 결과
    static let result7: URL? = URL(string: "\(Self.mockScheme)://\(Self.mockHost):8080/path/?key=value")
    /// test 8의 예상 결과
    static let result8: URL? = nil
    /// test 9의 예상 결과
    static let result9: URL? = nil
    /// test 10의 예상 결과
    static let result10: URL? = nil
}
