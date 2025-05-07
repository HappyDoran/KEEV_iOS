//
//  URLRequestBody.swift
//  Network
//
//  Created by junsungkim on 4/28/25.
//

import Foundation

/// URLRequest의 body에 담기 위한 데이터를 추상화한 열거형
public enum URLRequestBody {
    case data(Data)
    case serialize(Dictionary<String, Any>)
    case encodable(type: Encodable, encoder: JSONEncoder)
    
    /// 열거형의 각 케이스를 데이터로 변환하는 함수
    ///
    /// - .data의 경우, 가진 데이터를 그대로 데이터를 반환합니다.
    /// - .encodable의 경우, 특정 타입을 JSONEncoder로 인코딩하여 json형식의 데이터로 반환합니다.
    /// - .serialize의 경우, 특정 타입을 JSONSerialization.data(_:)로 인코딩하여 json형식의 데이터로 반환합니다.
    public func toData() throws -> Data {
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
