//
//  TokenError.swift
//  KEEV
//
//  Created by 김준성 on 12/30/24.
//

import Foundation

enum TokenError: Error {
    case tokenNotFound
    case tokenIsNil
    case decodeFail
}
