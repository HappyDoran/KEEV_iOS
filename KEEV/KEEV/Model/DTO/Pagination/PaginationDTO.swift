//
//  PaginationDTO.swift
//  KEEV
//
//  Created by Doran on 11/28/24.
//

import  SwiftUI

/// Pagination이 적용된 데이터 구조체
///
/// Pagination이 적용된 데이터 구조체입니다.
///
/// - Note: Event, Vibe 등 다양한 경우에서 사용하기 위해 제네릭으로 구현하였습니다.
/// - Author: Doran

import Foundation

/// Pagination이 적용된 데이터 구조체
///
/// json 디코딩을 해야하기 때문에 제네릭 타입도 Decodable 하고 struct 자체도 Decodable 합니다.
///
/// - Author: Doran
struct PaginationDTO<T: Decodable>: Decodable {
    let totalElements: Int
    let currentPage: Int
    let totalPages: Int
    let contents: [T]
    
    private enum CodingKeys: String, CodingKey {
        case totalElements
        case currentPage
        case totalPages
        case contents
    }
}

