//
//  String+Extension.swift
//  KEEV
//
//  Created by Yune Cho on 11/1/24.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    var isValidNickname: Bool {
        let nicknameRegex = "^[ㄱ-ㅎ가-힣A-Za-z0-9]{1,}$"
        return NSPredicate(format: "SELF MATCHES %@", nicknameRegex).evaluate(with: self)
    }
}
