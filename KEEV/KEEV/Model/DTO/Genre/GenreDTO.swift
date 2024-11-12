//
//  GenreDTO.swift
//  KEEV
//
//  Created by 김준성 on 11/12/24.
//

import Foundation

/// 장르 DTO 입니다
///
/// id와 name으로 구성되어 있습니다.
struct GenreDTO: Decodable, Hashable, Identifiable {
    /// 장르 id
    let id: Int
    /// 장르명
    let name: String
}
