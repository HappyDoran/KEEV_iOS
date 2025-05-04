//
//  File.swift
//  KeyValueStorage
//
//  Created by junsungkim on 5/1/25.
//

import Foundation

/// KeyValueStorage 모듈에서 사용되는 에러 정의입니다.
public enum StorageError: Error {

    /// 값을 인코딩하는 데 실패한 경우
    case encodingFailed

    /// 값을 디코딩하는 데 실패한 경우
    case decodingFailed

    /// Keychain 연산 중 시스템 오류가 발생한 경우 (status 코드 포함)
    case keychainError(status: OSStatus)

    /// 예상하지 못한 데이터 형식이 반환된 경우
    case unexpectedData

    /// 알 수 없는 오류가 발생한 경우
    case unknown
}
