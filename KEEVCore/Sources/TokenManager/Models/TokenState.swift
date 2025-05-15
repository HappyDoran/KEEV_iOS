//
//  TokenState.swift
//  KEEVCore
//
//  Created by junsungkim on 5/15/25.
//

public enum TokenState: Equatable, Sendable {
    case expired
    case valid(token: String)
}
