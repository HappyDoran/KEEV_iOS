//
//  SimpleEventDTO.swift
//  KEEV
//
//  Created by 김준성 on 11/12/24.
//

import Foundation

/// 서버와 통신할 때 쓰이는 이벤트 DTO 중 하나
///
/// 이벤트에 대한 간략한 정보를 보여줍니다.
/// 이 타입의 경우, 이벤트 정보를 간단하게 보여주는 경우 사용됩니다.
/// 아래와 같은 경우에서 주로 사용됩니다:
/// - 이벤트 목록을 보여줄 때
/// - 바이브에 간략하게 이벤트 정보를 보여줄 때
///
/// - Note: `==`의 기준을 '서로의 `id`가 같은가?'로 했습니다. 또한 hash의 기준 또한 `id`입니다.
/// - Author: newJunsung
struct SimpleEventDTO: Decodable, Identifiable, Hashable {
    /// 이벤트의 ID
    let id: String
    /// 이벤트의 이름
    let name: String
    /// 이벤트가 서버에 등록된 시점
    let createdDate: Date
    /// 이벤트가 시작되는 날짜
    let startDate: Date
    /// 이벤트가 끝나는 날짜
    let endDate: Date
    /// 이벤트 포스터의 URL 문자열
    let posterURLString: String
    /// 이벤트가 열리는 장소
    let placeName: String
}

extension SimpleEventDTO {
    static func == (lhs: SimpleEventDTO, rhs: SimpleEventDTO) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
