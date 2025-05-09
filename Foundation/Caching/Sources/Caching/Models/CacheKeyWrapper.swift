//
//  File.swift
//  Caching
//
//  Created by junsungkim on 5/9/25.
//

import Foundation

internal final class CacheKeyWrapper: NSObject {
    let key: AnyHashable
    
    init(key: some Hashable) {
        self.key = key
    }
    
    override var hash: Int { key.hashValue }
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? CacheKeyWrapper else {
            return false
        }
        return key == other.key
    }
}
