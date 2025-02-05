//
//  KEEVErrorHandler.swift
//  KEEV
//
//  Created by 김준성 on 1/8/25.
//

import Foundation

protocol KEEVErrorHandler {
    associatedtype Layer: LayerRepresentable
    
    func doWithException(caller: String, _ closure: () throws -> Void) throws
    func doWithException<T>(caller: String, _ closure: () throws -> T) throws -> T
    func doAsyncWithException(caller: String, _ closure: () async throws -> Void) async throws
    func doAsyncWithException<T>(caller: String, _ closure: () async throws -> T) async throws -> T
}

extension KEEVErrorHandler {
    /// 특정 함수에서 발생할 수 있는 에러를 KEEVError로 변환해주는 함수
    ///
    /// 클로저에서 에러가 발생하면, 그 에러를 KEEVError로 변환하여 throw 합니다.
    ///
    /// - Parameters:
    ///   - caller: 호출한 함수의 이름
    ///   - closure: 실행하고픈 함수.
    ///
    /// - Warning: 클로저 내에서 순환참조가 발생할 수 있습니다. 필요하다면 `[weak self]`를 사용해주세요.
    ///
    /// - Throws: catch한 에러가 `KEEVError`라면, 해당 `KEEVError`와 동일한 occurPoint를 지닌 `KEEVError`를 발생시킵니다.
    /// - Author: newJunsung
    func doWithException(caller: String, _ closure: () throws -> Void) throws {
        do {
            try closure()
        } catch let keevError as KEEVError {
            throw throwKEEVError(caller: caller, previousKEEVError: keevError)
        } catch let otherError {
            throw throwKEEVError(caller: caller, occurPoint: .local(description: otherError.localizedDescription))
        }
    }
    
    /// 특정 함수에서 발생할 수 있는 에러를 KEEVError로 변환해주는 함수
    ///
    /// 클로저에서 에러가 발생하면, 그 에러를 KEEVError로 변환하여 throw 합니다.
    ///
    /// - Parameters:
    ///   - caller: 호출한 함수의 이름
    ///   - closure: 실행하고픈 함수.
    ///
    /// - Warning: 클로저 내에서 순환참조가 발생할 수 있습니다. 필요하다면 `[weak self]`를 사용해주세요.
    /// - Throws: catch한 에러가 `KEEVError`라면, 해당 `KEEVError`와 동일한 occurPoint를 지닌 `KEEVError`를 발생시킵니다.
    /// - Returns: 클로저에서 리턴한 타입, 값과 동일한 타입, 값을 리턴합니다.
    /// - Author: newJunsung
    func doWithException<T>(caller: String, _ closure: () throws -> T) throws -> T {
        do {
            return try closure()
        } catch let keevError as KEEVError {
            throw throwKEEVError(caller: caller, previousKEEVError: keevError)
        } catch let otherError {
            throw throwKEEVError(caller: caller, occurPoint: .local(description: otherError.localizedDescription))
        }
    }
    
    /// 특정 함수에서 발생할 수 있는 에러를 KEEVError로 변환해주는 함수
    ///
    /// 클로저에서 에러가 발생하면, 그 에러를 KEEVError로 변환하여 throw 합니다.
    ///
    /// - Parameters:
    ///   - caller: 호출한 함수의 이름
    ///   - closure: 실행하고픈 함수.
    ///
    /// - Warning: 클로저 내에서 순환참조가 발생할 수 있습니다. 필요하다면 `[weak self]`를 사용해주세요.
    /// - Throws: catch한 에러가 `KEEVError`라면, 해당 `KEEVError`와 동일한 occurPoint를 지닌 `KEEVError`를 발생시킵니다.
    /// - Author: newJunsung
    func doAsyncWithException(caller: String, _ closure: () async throws -> Void) async throws {
        do {
            try await closure()
        } catch let keevError as KEEVError {
            throw throwKEEVError(caller: caller, previousKEEVError: keevError)
        } catch let otherError {
            throw throwKEEVError(caller: caller, occurPoint: .local(description: otherError.localizedDescription))
        }
    }
    
    /// 특정 함수에서 발생할 수 있는 에러를 KEEVError로 변환해주는 함수
    ///
    /// 클로저에서 에러가 발생하면, 그 에러를 KEEVError로 변환하여 throw 합니다.
    ///
    /// - Parameters:
    ///   - caller: 호출한 함수의 이름
    ///   - closure: 실행하고픈 함수.
    ///
    /// - Warning: 클로저 내에서 순환참조가 발생할 수 있습니다. 필요하다면 `[weak self]`를 사용해주세요.
    /// - Throws: catch한 에러가 `KEEVError`라면, 해당 `KEEVError`와 동일한 occurPoint를 지닌 `KEEVError`를 발생시킵니다.
    /// - Returns: 클로저에서 리턴한 타입, 값과 동일한 타입, 값을 리턴합니다.
    /// - Author: newJunsung
    func doAsyncWithException<T>(caller: String, _ closure: () async throws -> T) async throws -> T {
        do {
            return try await closure()
        } catch let keevError as KEEVError {
            throw throwKEEVError(caller: caller, previousKEEVError: keevError)
        } catch let otherError {
            throw throwKEEVError(caller: caller, occurPoint: .local(description: otherError.localizedDescription))
        }
    }
    
    /// 파라미터에 대한 KEEVError를 발생시키는 함수
    ///
    /// - Parameters:
    ///   - caller: 에러를 발생시킨 함수 또는 생성자에 대한 문자열
    ///   - occurPoint: 에러가 발생한 지점
    ///
    /// - Note: `KEEVError`의 프로퍼티인 `previousError`가 nil을 가집니다.
    ///
    /// - Returns: 파라미터를 바탕으로 만든 KEEVError
    /// - Author: newJunsung
    func throwKEEVError(caller: String, occurPoint: KEEVError.OccurPoint) -> KEEVError {
        KEEVError(
            layer: Layer.layer,
            caller: caller,
            occurPoint: occurPoint,
            previousError: nil
        )
    }
    
    /// 파라미터에 대한 KEEVError를 발생시키는 함수
    ///
    /// - Parameters:
    ///   - caller: 에러를 발생시킨 함수 또는 생성자에 대한 문자열
    ///   - occurPoint: 에러가 발생한 지점
    ///   - previousError: 이전에 발생한 KEEVError가 아닌 Error
    ///
    /// - Note: 만약 `KEEVError`를 `previousError`에 주입하고 싶다면, `throwKEEVError(caller: String, previousKEEVError: KEEVError)`를 실행하면 됩니다.
    ///
    /// - Returns: 파라미터를 바탕으로 만든 KEEVError
    /// - Author: newJunsung
    func throwKEEVError(caller: String, occurPoint: KEEVError.OccurPoint, previousError: Error) -> KEEVError {
        KEEVError(
            layer: Layer.layer,
            caller: caller,
            occurPoint: occurPoint,
            previousError: previousError
        )
    }
    
    /// 파라미터에 대한 KEEVError를 발생시키는 함수
    ///
    /// - Parameters:
    ///   - caller: 에러를 발생시킨 함수 또는 생성자에 대한 문자열
    ///   - previousKEEVError: 지정한 함수 이전에 발생한 함수.
    ///
    /// - Returns: 파라미터를 바탕으로 만든 KEEVError
    /// - Author: newJunsung
    func throwKEEVError(caller: String, previousKEEVError: KEEVError) -> KEEVError {
        KEEVError(layer: Layer.layer, caller: caller, previousKEEVError: previousKEEVError)
    }
}
