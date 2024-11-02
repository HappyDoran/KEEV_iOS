//
//  String+Extension.swift
//  KEEV
//
//  Created by Doran on 11/2/24.
//

import Foundation

/// Date 문자열 형태를 나열한 열거형
///
/// - Author: Doran
enum DateFormat: String {
    case yyyyMMdd = "yyyyMMdd"
    case yyyyMMDD = "yyyy.MM.dd"
    case yyyyMMddWithDash = "yyyy-MM-dd"
    case mmddyyyy = "MM/dd/yyyy"
}

extension String {
    static private let dateFormatter: DateFormatter = DateFormatter()
    
    /// 문자열을 주어진 형식에 따라 Date로 변환하는 함수
    ///
    /// - Parameters:
    ///   - format: 날짜를 변환할 문자열 형식. 예: "yyyy-MM-dd", "MM/dd/yyyy" 등.
    ///
    /// - Returns: 변환된 Date 객체 또는 nil
    ///
    /// - Example:
    /// ```swift
    /// let dateString = "2024.10.19"
    /// if let date = dateString.toDate(format: "yyyy.MM.dd") {
    ///     print(date) // 해당 날짜의 Date 객체
    /// }
    /// ```
    /// - Author: Doran
    func toDate(format: DateFormat) -> Date? {
        String.dateFormatter.dateFormat = format.rawValue
        return String.dateFormatter.date(from: self)
    }
}
