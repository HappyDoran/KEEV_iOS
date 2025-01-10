//
//  UserDefaultsUtility.swift
//  KEEV
//
//  Created by Yune Cho on 10/17/24.
//

import Foundation

/// UserDefaults를 사용하기 위한 Utility입니다.
///
/// UserDefaults의 set, get, remove 기능을 사용하기 위한 Utility입니다.
///
/// - Author: 라움
final class UserDefaultsUtility: LayerRepresentable, KEEVErrorHandler {
    static var layer: LayerType = .utility(of: "UserDefaultsUtility")
    
    typealias Layer = UserDefaultsUtility
    
    private let userDefaults: UserDefaults
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    
    /// 생성자입니다.
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.jsonEncoder = JSONEncoder()
        self.jsonDecoder = JSONDecoder()
    }
    
    /// UserDefaults에 값을 저장하는 함수입니다.
    ///
    /// - Parameters:
    ///   - value: 저장할 값
    ///   - key: 키 값
    ///
    /// Codable을 채택하는 타입의 입력값과 키 값으로 사용할 값을 인자로 받아서 UserDefaults에 저장하는 함수입니다.
    ///
    /// - Throws: 인코딩 에러가 발생할 경우 error를 throw합니다.
    ///
    /// - Author: 라움
    func set<InputType: Codable>(_ value: InputType, forKey key: String) throws {
        let encodedData = try doWithException(caller: "set(_ value: InputType, forKey key: String)") {
            try jsonEncoder.encode(value)
        }
        userDefaults.set(encodedData, forKey: key)
    }
        
    /// UserDefaults에서 값을 가져오는 함수입니다.
    ///
    /// - Parameters:
    ///   - type: 리턴할 값의 타입
    ///   - key: 키 값
    ///
    /// Codable을 채택하는 타입과 키 값을 인자로 받아서 키 값에 해당하는 값을 가져와서 인자로 받은 타입으로 디코딩 한 후 리턴해주는 함수입니다.
    ///
    /// - Throws: 디코딩 에러가 발생할 경우 error를 throw합니다.
    /// - Returns: Codable을 채택하는 OutputType의 값 혹은 nil
    ///
    /// - Author: 라움
    func get<OutputType: Codable>(_ type: OutputType.Type, forKey key: String) throws -> OutputType? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        
        let decodedData = try doWithException(caller: "get(_ type: OutputType.Type, forKey key: String)") {
            try jsonDecoder.decode(OutputType.self, from: data)
        }
        return decodedData
    }
    
    /// UserDefaults에서 값을 삭제하는 함수입니다.
    ///
    /// - Parameters:
    ///   - key: 키 값
    ///
    /// 키 값을 인자로 받아서 UserDefaults에서 키 값에 해당하는 값을 삭제하는 함수입니다.
    ///
    /// - Author: 라움
    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
