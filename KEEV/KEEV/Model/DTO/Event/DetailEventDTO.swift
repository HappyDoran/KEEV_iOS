//
//  DetailEventDTO.swift
//  KEEV
//
//  Created by 김준성 on 11/12/24.
//

import Foundation

/// 이벤트 상세 정보입니다.
///
/// id, 이름, 이벤트 유형, 장르, 날짜 정보 등으로 구성되어 있습니다.
/// 이 DTO는 이벤트 상세 뷰에서 주로 사용됩니다.
///
/// - Author: newJunsung
struct DetailEventDTO: Decodable, Hashable, Identifiable {
    let id: String
    
    /// 이벤트의 이름
    let name: String
    
    /// 이벤트의 유형(ex. 콘서트, 페스티벌 등)
    let types: [EventTypeDTO]
    
    /// 이벤트의 장르(ex. 락, 재즈, JPOP, 힙합 등)
    let genres: [GenreDTO]
    
    /// 이벤트가 생성된 날짜
    let createdDate: Date
    
    /// 이벤트가 시작되는 날짜
    let startDate: Date
    
    /// 이벤트가 종료되는 날짜
    let endDate: Date
    
    /// 이벤트가 시작되는 시간(ex. 19시 00분)
    let startTime: Date
    
    /// 포스터 URL 문자열
    let posterURLString: String
    
    /// 이벤트에 대한 상세 설명 텍스트
    let description: String?
    
    /// 이벤트에 대한 상세 설명 이미지
    let descriptionImagesURLStrings: [String]?
    
    /// 장소
    let place: PlaceDTO
    
    /// 이벤트 참여 아티스트
    let artists: [SimpleArtistDTO]
}

struct EventTypeDTO: Decodable, Hashable, Identifiable {
    let id: Int
    let name: String
}
