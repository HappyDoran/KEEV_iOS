//
//  File.swift
//  KeyValueStorage
//
//  Created by junsungkim on 5/1/25.
//

import Foundation

public enum StorageError: Error {
    case encodingFailed
    case decodingFailed
    case keychainError(status: OSStatus)
    case unexpectedData
    case unknown
}
