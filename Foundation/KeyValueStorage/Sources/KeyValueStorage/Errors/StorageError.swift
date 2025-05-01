//
//  File.swift
//  KeyValueStorage
//
//  Created by junsungkim on 5/1/25.
//

import Foundation

enum StorageError: Error {
    case encodingFailed
    case decodingFailed
    case keychainError(status: OSStatus)
    case unknown
}
