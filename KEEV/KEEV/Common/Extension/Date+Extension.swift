//
//  Date+Extension.swift
//  KEEV
//
//  Created by Doran on 10/19/24.
//

import Foundation

extension Date {
    private static let dateFormatter: DateFormatter = DateFormatter()

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
