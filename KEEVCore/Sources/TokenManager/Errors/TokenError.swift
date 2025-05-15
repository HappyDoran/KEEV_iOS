//
//  TokenError.swift
//  KEEVCore
//
//  Created by junsungkim on 5/15/25.
//

import Foundation

public enum TokenError: Error, Sendable, Equatable {
    case invalidToken
    case expiredToken
}
