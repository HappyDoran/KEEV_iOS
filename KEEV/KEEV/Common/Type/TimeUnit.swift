//
//  TimeUnit.swift
//  KEEV
//
//  Created by 김준성 on 10/28/24.
//

import Foundation

/// 디스크의 용량 단위를 나타내는 열거형
///
/// 디스크의 용량을 나타냅니다.
/// case로는 `bytes`, `kilobytes`, `megabytes`, `gigabytes`가 있습니다.
///
/// - Author: newJunsung
enum TimeUnit {
    // MARK: Static functions
    
    /// 두 유닛을 더해줍니다.
    ///
    /// 두 유닛의 case가 무엇이든 상관없이, 시간을 계산하여 `seconds` 열거형으로 나타냅니다.
    ///
    /// - Returns: TimeUnit.seconds
    /// - Author: newJunsung
    static func + (lhs: TimeUnit, rhs: TimeUnit) -> TimeUnit {
        .seconds(of: lhs.toSeconds + rhs.toSeconds)
    }
    
    /// 두 유닛을 빼줍니다.
    ///
    /// 두 유닛의 case가 무엇이든 상관없이, 시간을 계산하여 `seconds` 열거형으로 나타냅니다.
    ///
    /// - Returns: TimeUnit.seconds
    /// - Author: newJunsung
    static func - (lhs: TimeUnit, rhs: TimeUnit) -> TimeUnit {
        .seconds(of: lhs.toSeconds - rhs.toSeconds)
    }
    
    // MARK: Case
    
    case seconds(of: TimeInterval)
    case minutes(of: Int)
    case hours(of: Int)
    case days(of: Int)
    
    // MARK: Internal attributes
    
    /// 각 case들을 초 단위로 바꿔서 보여주는 변수
    var toSeconds: TimeInterval {
        switch self {
        case .seconds(of: let seconds): return seconds
        case .minutes(of: let minutes): return TimeInterval(minutes) * 60
        case .hours(of: let hours): return TimeInterval(hours) * 60 * 60
        case .days(of: let days): return TimeInterval(days) * 60 * 60 * 24
        }
    }
}
