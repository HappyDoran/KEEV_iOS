//
//  ConcertDTO.swift
//  KEEV
//
//  Created by Doran on 10/16/24.
//

import Foundation

/// 공연 정보를 담을 모델입니다.
///
///  공연에 대한 데이터를 받을 구조체입니다.
///
/// - Author: Doran
struct ConcertDTO: Codable {
    /// 공연 고유 ID
    let id: String
    /// 공연 이름
    let name: String
    /// 공연 시작 날짜
    let startDate: String
    /// 공연 종료 날짜
    let endDate: String
    /// 공연 위치
    let location: String
    /// 공연 포스터
    let poster: String
    
    /// 디코딩을 위한 CodingKey
    enum CodingKeys: String, CodingKey {
        case id = "mt20id"
        case name = "prfnm"
        case startDate = "prfpdfrom"
        case endDate = "prfpdto"
        case location = "fcltynm"
        case poster
    }
}


