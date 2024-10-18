//
//  XMLKey.swift
//  KEEV
//
//  Created by Doran on 10/18/24.
//

import Foundation
/// XMLKey를 정의 해놓은 열거형
///
///  XML Document의 tag 타입에 맞춰야 한다.
///
/// - Author: Doran
enum XMLKey: String {
    case id = "mt20id"
    case title = "prfnm"
    case startDate = "prfpdfrom"
    case endDate = "prfpdto"
    case place = "fcltynm"
    case poster = "poster"
}
