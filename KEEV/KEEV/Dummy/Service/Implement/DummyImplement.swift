//
//  DummyImplement.swift
//  KEEV
//
//  Created by Doran on 10/16/24.
//


import Foundation

enum ConcertRouter {
    case concertInfo(eddate: String, cpage: String, rows:String)
}

extension ConcertRouter: HTTPRequestable {
    var method: HTTPMethod { .get }
    
    var scheme: String { "http" }
    
    var host: String { AppEnvironment.kopisBaseURL.host ?? "" }
    
    var port: Int? { nil }
    
    var path: [String]? {
        var path = ["openApi","restful","pblprfr"]
        
        return path
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .concertInfo(let eddate, let cpage, let rows):
            return [
                URLQueryItem(name: "service", value: AppEnvironment.kopisApiKey),
                URLQueryItem(name: "stdate", value: "20240304"),
                URLQueryItem(name: "eddate", value: eddate),
                URLQueryItem(name: "cpage", value: cpage),
                URLQueryItem(name: "rows", value: rows),
                URLQueryItem(name: "shcate", value: "CCCD")
            ]
        }
    }
}
