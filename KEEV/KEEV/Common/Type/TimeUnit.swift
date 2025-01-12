//
//  TimeUnit.swift
//  KEEV
//
//  Created by 김준성 on 10/28/24.
//

import Foundation

/// 시간 단위를 나타내는 열거형
///
/// 시간단위를 나타냅니다.
/// case로는 `seconds`, `minutes`, `hours`, `days`가 있습니다.
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
    
    /// 두 Date 간의 차이를 TimeUnit으로 변경해주는 함수.
    ///
    /// - Parameters:
    ///   - lhs: 기준이 되는 Date. rhs보다 반드시 크거나 같아야 합니다.
    ///   - rhs: 빼고 싶은 Date. lhs보다 반드시 작거나 같아야 합니다.
    ///
    /// - Important: 왼쪽의 Date(lhs)가 반드시 오른쪽(rhs)보다 커야합니다. 크지 않다면, 반드시 `.justNow`를 반환합니다.
    ///
    /// - Returns: 두 날짜 간의 차이를 계산하여 가장 크게 표현할 수 있는 시간단위를 리턴합니다.
    /// - Author: newJunsung
    static func subtractDate(_ lhs: Date, with rhs: Date) -> TimeUnit {
        let timeDifference = Int(lhs.timeIntervalSince1970 - rhs.timeIntervalSince1970)
        let dayDifference = timeDifference / Int(TimeUnit.days(of: 1).toSeconds)
        
        if dayDifference >= 365 {
            return .years(of: dayDifference / 365)
        }
        
        if dayDifference >= 30 {
            return .months(of: dayDifference / 30)
        }
        
        if dayDifference >= 7 {
            return .weeks(of: dayDifference / 7)
        }
        
        if dayDifference >= 1 {
            return .days(of: dayDifference)
        }
        
        let underDayDifference = timeDifference % Int(TimeUnit.days(of: 1).toSeconds)
        
        if underDayDifference >= 60 * 60 {
            return .hours(of: underDayDifference / 60 * 60)
        }
        
        if underDayDifference >= 60 {
            return .minutes(of: underDayDifference / 60)
        }
        
        if underDayDifference >= 10 {
            return .seconds(of: TimeInterval(underDayDifference))
        }
        
        return .justNow
    }
    
    // MARK: Case
    /// 지금, description으로 표현 시, "방금"이라고 출력합니다.
    case justNow
    /// 초를 표현하는 케이스
    case seconds(of: TimeInterval)
    /// 분을 표현하는 케이스
    case minutes(of: Int)
    /// 시간을 표현하는 케이스
    case hours(of: Int)
    /// 일을 표현하는 케이스
    case days(of: Int)
    /// 주를 표현하는 케이스
    case weeks(of: Int)
    /// 달을 표현하는 케이스
    case months(of: Int)
    /// 년을 표현하는 케이스
    case years(of: Int)
    
    // MARK: Internal attributes
    
    /// 각 case들을 초 단위로 바꿔서 보여주는 변수
    var toSeconds: TimeInterval {
        switch self {
        case .justNow: return 0
        case .seconds(of: let seconds): return seconds
        case .minutes(of: let minutes): return TimeInterval(minutes) * 60
        case .hours(of: let hours): return TimeInterval(hours) * 60 * 60
        case .days(of: let days): return TimeInterval(days) * 60 * 60 * 24
        case .weeks(of: let weeks): return TimeInterval(weeks) * 60 * 60 * 24 * 7
        case .months(of: let months): return TimeInterval(months) * 60 * 60 * 24 * 30
        case .years(of: let years): return TimeInterval(years) * 60 * 60 * 24 * 365
        }
    }
}

extension TimeUnit: CustomStringConvertible {
    var description: String {
        switch self {
        case .justNow:
            "방금"
        case .seconds(let of):
            "\(Int(of))초"
        case .minutes(let of):
            "\(of)분"
        case .hours(let of):
            "\(of)시간"
        case .days(let of):
            "\(of)일"
        case .weeks(let of):
            "\(of)주"
        case .months(let of):
            "\(of)달"
        case .years(let of):
            "\(of)년"
        }
    }
}
