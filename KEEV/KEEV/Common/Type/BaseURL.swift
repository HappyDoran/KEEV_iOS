//
//  BaseURL.swift
//  KEEV
//
//  Created by Doran on 11/27/24.
//

struct BaseURL: URLBaseComposable {
    let scheme: String
    let host: String
    let port: Int?
    var path: [String]?
}
