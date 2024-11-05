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
  
    /// 이메일 형식을 확인하는 프로퍼티
    ///
    /// 정규표현식과 비교하여 입력한 이메일이 이메일 형식과 맞는지 유효성을 확인합니다.
    ///
    /// 이메일 형식이 맞으면 true, 아니면 false 값을 리턴합니다.
    ///
    /// - Author: 라움
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    /// 닉네임에 특수문자가 포함되어있는지 확인하는 프로퍼티
    ///
    /// 정규표현식과 비교하여 입력한 닉네임에 특수문자가 포함되어있는지 유효성을 확인합니다.
    ///
    /// 특수문자가 포함되어있지 않으면 true, 포함되어 있으면 false를 리턴합니다.
    ///
    /// - Author: 라움
    var isValidNickname: Bool {
        let nicknameRegex = "^[ㄱ-ㅎ가-힣A-Za-z0-9]{1,}$"
        return NSPredicate(format: "SELF MATCHES %@", nicknameRegex).evaluate(with: self)
    }
}
