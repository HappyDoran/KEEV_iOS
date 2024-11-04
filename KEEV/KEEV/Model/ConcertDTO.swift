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
struct ConcertDTO: Codable, Hashable {
    /// 공연 고유 ID
    let id: String
    /// 공연 이름
    let title: String
    /// 공연 시작 날짜
    let startDate: String
    /// 공연 종료 날짜
    let endDate: String
    /// 공연 위치
    let place: String
    /// 공연 포스터
    let poster: String
    
    /// XML 파싱시 공백이나 줄바꿈 등 불필요한 문자열이 포함되어 있기 때문에 이를 제거해주기 위함
    init(id: String, title: String, startDate: String, endDate: String, place: String, poster: String) {
        self.id = id.trimmingCharacters(in: .whitespacesAndNewlines)
        self.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        self.startDate = startDate.trimmingCharacters(in: .whitespacesAndNewlines)
        self.endDate = endDate.trimmingCharacters(in: .whitespacesAndNewlines)
        self.place = place.trimmingCharacters(in: .whitespacesAndNewlines)
        self.poster = poster.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 디코딩을 위한 CodingKey
    enum CodingKeys: String, CodingKey {
        case id = "mt20id"
        case title = "prfnm"
        case startDate = "prfpdfrom"
        case endDate = "prfpdto"
        case place = "fcltynm"
        case poster = "poster"
    }
}

