//
//  Date+Extension.swift
//  KEEV
//
//  Created by Doran on 10/19/24.
//

import Foundation

extension Date {
    static private let dateFormatter: DateFormatter = DateFormatter()
    static private let calendar = Calendar.current
    
    /// 특정 날의 시작점을 Date로 바꿔주는 함수
    ///
    /// - Parameters:
    ///   - year: 년
    ///   - month: 월
    ///   - day: 일
    ///
    /// 년, 월, 일을 입력하면 그 날의 0시 0분을 Date로 반환하는 함수입니다.
    ///
    /// - Returns: 지정한 날의 0시 0분을 변환한 Date
    /// - Author: newJunsung
    static func startOfDay(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 0
        components.minute = 0
        components.second = 0
        components.nanosecond = 0
        return Date.calendar.date(from: components)!
    }
    
    /// Date 타입의 객체를 사용자가 정한 형식의 문자열로 변환하는 함수
    ///
    /// - Parameters:
    ///   - format : 날짜를 변환할 문자열 형식. 예: "yyyy-MM-dd", "MM/dd/yyyy" 등.
    ///
    /// `DateFormatter`를 사용하여 날짜를 지정된 형식으로 문자열로 변환합니다.
    ///
    /// - Returns: 변환된 날짜 문자열
    ///
    /// - Example:
    /// ```swift
    /// let date = Date()
    /// let formattedDate = date.toString(format: "yyyyMMdd")
    /// print(formattedDate) // "20241019"
    /// ```
    /// - Author: Doran
    func toString(format: String) -> String {
        Date.dateFormatter.dateFormat = format
        return Date.dateFormatter.string(from: self)
    }
    
    /// Date 타입의 날짜와 인자로 받은 날짜 사이의 차이를 계산하는 함수
    ///
    /// - Parameters:
    ///   - date: 날짜 차이를 계산하고 싶은 날짜
    ///
    /// Date 타입의 날짜와 인자로 받은 날짜 사이의 차이를 계산하는 함수입니다.
    ///
    /// - Returns: 날짜 차이 값을 옵셔널로 리턴
    ///
    /// - Example:
    /// ```swift
    /// let date = Date()
    /// if let difference = date.difference {
    ///     print(difference)
    /// }
    /// ```
    ///
    /// - Author: 라움
    func difference(from date: Date) -> Int? {
        let lhs = Int(self.timeIntervalSince1970 / TimeUnit.days(of: 1).toSeconds)
        let rhs = Int(date.timeIntervalSince1970 / TimeUnit.days(of: 1).toSeconds)

        return rhs - lhs
    }
}

