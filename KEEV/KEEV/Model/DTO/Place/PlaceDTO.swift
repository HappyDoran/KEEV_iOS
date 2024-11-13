//
//  PlaceDTO.swift
//  KEEV
//
//  Created by 김준성 on 11/12/24.
//

import Foundation

/// 장소 DTO 입니다
struct PlaceDTO: Codable, Hashable, Identifiable {
    let id: Int
    
    /// 장소 이름
    let name: String
    
    /// 주소(ex. 경상북도 포항시 청암로 77 남자기숙사 18동 112호)
    let address: String
    
    /// 나라 이름
    let contry: String
    
    /// 위도
    let latitude: Double
    
    /// 경도
    let longitude: Double
}
