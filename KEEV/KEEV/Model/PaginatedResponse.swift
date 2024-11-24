//
//  PaginatedResponse.swift
//  KEEV
//
//  Created by Yune Cho on 11/22/24.
//

import Foundation

/// Pagination이 적용된 데이터 구조체
///
/// Pagination이 적용된 데이터 구조체입니다.
///
/// - Note: Event, Vibe 등 다양한 경우에서 사용하기 위해 제네릭으로 구현하였습니다.
/// - Author: 라움
struct PaginatedResponse<T> {
    let totalPages: Int
    let currentPage: Int
    let totalElements: Int
    let contents: [T]
}
