//
//  EventResponseDTO.swift
//  KEEV
//
//  Created by Doran on 11/28/24.
//

/// 디테일 이벤트가 배열로 events라는 이름의 배열로 날아오기 때문에 구조체 생성
///
/// 해당 구조체를 사용하지 않고도 Json데이터를 추출해서 만들 수 있지만 딸깍 하고싶기 때문에 만들었습니다.
///
/// - Author: Doran
struct EventResponseDTO: Decodable {
    let events: [DetailEventDTO]
}
