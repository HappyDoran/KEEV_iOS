//
//  SimpleArtistDTO.swift
//  KEEV
//
//  Created by 김준성 on 11/12/24.
//

import Foundation

/// 서버와 통신할 때 쓰이는 아티스트 DTO 중 하나
///
/// 아티스트에 대한 간략한 정보를 보여줍니다.
/// 이 타입의 경우, 아티스트 정보를 간단하게 보여주는 경우 사용됩니다.
/// 아티스트의 id와 이름, 프로필 이미지 URL 문자열이 있습니다.
/// 아래와 같은 경우에서 주로 사용됩니다:
/// - 이벤트 상세 정보에서 참여 아티스트를 보여줄 때
///
/// - Note: `==`의 기준을 '서로의 `id`가 같은가?'로 했습니다. 또한 hash의 기준 또한 `id`입니다.
/// - Author: newJunsung
struct SimpleArtistDTO: Decodable, Hashable, Identifiable {
    /// 아티스트의 ID
    let id: Int
    /// 아티스트 이름
    let name: String
    /// 아티스트의 프로필 이미지 URL 문자열
    let profileImageURLString: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profileImageURLString = "profileImageURL"
    }
}

extension SimpleArtistDTO {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
