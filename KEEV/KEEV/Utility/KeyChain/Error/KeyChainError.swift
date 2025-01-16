//
//  KeyChainError.swift
//  KEEV
//
//  Created by Doran on 10/30/24.
//

/// KeyChainError: KeyChain 작업에 대한 오류를 처리하기 위한 열거형
///
///  키체인 작업을 할 때 발생하는 에러를 그룹화
///
/// - Author: Doran
enum KeyChainError: Error {
    case invalidToken
    case notFound
    case deleteFailed
    case addFailed
}
