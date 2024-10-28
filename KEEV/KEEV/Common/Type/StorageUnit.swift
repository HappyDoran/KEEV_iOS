//
//  StorageUnit.swift
//  KEEV
//
//  Created by 김준성 on 10/28/24.
//

/// 디스크의 용량 단위를 나타내는 열거형
///
/// 디스크의 용량을 나타냅니다.
/// case로는 `bytes`, `kilobytes`, `megabytes`, `gigabytes`가 있습니다.
///
/// - Author: newJunsung
enum StorageUnit {
    /// 두 유닛을 더해줍니다.
    ///
    /// 두 유닛의 case가 무엇이든 상관없이, 용량을 계산하여 `bytes` 열거형으로 나타냅니다.
    ///
    /// - Returns: StorageUnit.bytes
    /// - Author: newJunsung
    static func + (lhs: StorageUnit, rhs: StorageUnit) -> StorageUnit {
        .bytes(of: lhs.toBytes + rhs.toBytes)
    }
    
    /// 두 유닛을 빼줍니다.
    ///
    /// 두 유닛의 case가 무엇이든 상관없이, 용량을 계산하여 `bytes` 열거형으로 나타냅니다.
    ///
    /// - Returns: StorageUnit.bytes
    /// - Author: newJunsung
    static func - (lhs: StorageUnit, rhs: StorageUnit) -> StorageUnit {
        .bytes(of: lhs.toBytes - rhs.toBytes)
    }
    
    case bytes(of: UInt)
    case kilobytes(of: UInt)
    case megabytes(of: UInt)
    case gigabytes(of: UInt)
    
    /// 각 case들을 `bytes` 단위의 UInt로 바꿔서 보여주는 변수
    var toBytes: UInt {
        switch self {
        case .bytes(of: let bytes): return bytes
        case .kilobytes(of: let kilobytes): return kilobytes * 1024
        case .megabytes(of: let megabytes): return megabytes * 1024 * 1024
        case .gigabytes(of: let gigabytes): return gigabytes * 1024 * 1024 * 1024
        }
    }
}
