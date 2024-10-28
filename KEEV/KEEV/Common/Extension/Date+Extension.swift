//
//  Date+Extension.swift
//  KEEV
//
//  Created by Doran on 10/19/24.
//

import Foundation

extension Date {
    private static let dateFormatter: DateFormatter = DateFormatter()
    
    /// Date 타입의 날짜와 오늘 날짜 사이의 차이를 저장하는 계산 프로퍼티
    ///
    /// Date 타입의 날짜와 오늘 날짜 사이의 차이를 저장하는 계산 프로퍼티입니다.
    ///
    /// - Example:
    /// ```swift
    /// let date = Date()
    /// if let difference = date.difference {
    ///     print(difference)
    /// }
    /// ```
    /// - Author: 라움
    var difference: Int? {
        let calendar = Calendar.current
        guard let count = calendar.dateComponents([.day], from: self, to: Date()).day else { return nil }
        
        return count
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
}
