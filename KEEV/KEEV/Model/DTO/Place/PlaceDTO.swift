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
}
