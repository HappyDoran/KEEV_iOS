//
//  URLRequestBody.swift
//  Network
//
//  Created by junsungkim on 4/28/25.
//

import Foundation

public enum URLRequestBody {
    case data(Data)
    case serialize(Dictionary<String, Any>)
    case encodable(type: Encodable, encoder: JSONEncoder)
    
    internal func toData() throws -> Data {
        switch self {
        case .data(let data):
            return data
        case .serialize(let dict):
            return try JSONSerialization.data(withJSONObject: dict)
        case .encodable(type: let encodable, encoder: let encoder):
            return try encoder.encode(encodable)
        }
    }
}
