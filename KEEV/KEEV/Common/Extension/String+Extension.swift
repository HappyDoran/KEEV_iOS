//
//  String+Extension.swift
//  KEEV
//
//  Created by Yune Cho on 11/1/24.
//

import Foundation

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
    func toDate(format: String) -> Date? {
        String.dateFormatter.dateFormat = format
        return String.dateFormatter.date(from: self)
    }
}
