//
//  Expirable.swift
//  Caching
//
//  Created by junsungkim on 5/8/25.
//

import Foundation

internal final class ExpirableObject<T> {
    let value: T
    let expiration: Date?
    
    var isExpired: Bool {
        guard let expiration = expiration else { return false }
        return .now > expiration
    }
    
    init(value: T, expiration: Date?) {
        self.value = value
        self.expiration = expiration
    }
}
