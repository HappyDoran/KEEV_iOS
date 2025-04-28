//
//  BaseURL.swift
//  KEEVCore
//
//  Created by junsungkim on 4/28/25.
//

public protocol BaseURL {
    var scheme: String { get }
    var host: String { get }
    var port: Int? { get }
}
