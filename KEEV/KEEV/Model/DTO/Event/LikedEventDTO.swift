//
//  LikedEventDTO.swift
//  KEEV
//
//  Created by Yune Cho on 2/16/25.
//

import Foundation

/// 서버와 통신할 때 쓰이는 관심 이벤트 DTO
///
/// 관심 이벤트에 대한 간략한 정보를 보여줍니다.
/// 이 타입의 경우, 관심 이벤트 정보를 간단하게 보여주는 경우 사용됩니다.
/// 아래와 같은 경우에서 주로 사용됩니다:
/// - 관심 이벤트 목록을 보여줄 때
/// - 프로필에 간략하게 관심 이벤트 정보를 보여줄 때
///
/// - Author: 라움
struct LikedEventDTO: Decodable, Identifiable {
    /// 이벤트의 ID
    let id: String
    /// 이벤트의 이름
    let name: String
    /// 이벤트 포스터의 URL 문자열
    let posterURLString: String
    /// 이벤트가 시작되는 날짜
    let startDate: Date
    /// 이벤트가 끝나는 날짜
    let endDate: Date
    /// 이벤트가 열리는 장소
    let placeNames: [String]
    /// 관심 표시 시간
    let likedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case posterURLString = "posterURL"
        case startDate
        case endDate
        case placeNames = "placeNameList"
        case likedAt
    }
    
    init(id: String, name: String, posterURLString: String, startDate: Date, endDate: Date, placeNames: [String], likedAt: Date) {
        self.id = id
        self.name = name
        self.posterURLString = posterURLString
        self.startDate = startDate
        self.endDate = endDate
        self.placeNames = placeNames
        self.likedAt = likedAt
    }
    
    /// 디코딩 데이터에 대해서 날짜를 포매팅 해주고 초기값을 생성
    ///
    /// - Author: 라움
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let tempStartDate = try container.decode(String.self, forKey: .startDate)
        let tempEndDate = try container.decode(String.self, forKey: .endDate)
        let tempLikedAt = try container.decode(String.self, forKey: .endDate)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.posterURLString = try container.decode(String.self, forKey: .posterURLString)
        self.startDate = tempStartDate.toDate(format: "yyyy-MM-dd") ?? .now
        self.endDate = tempEndDate.toDate(format: "yyyy-MM-dd") ?? .now
        self.placeNames = try container.decode([String].self, forKey: .placeNames)
        self.likedAt = tempLikedAt.toDate(format: "yyyy-MM-dd") ?? .now
    }
}
