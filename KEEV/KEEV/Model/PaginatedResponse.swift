//
//  PaginatedResponse.swift
//  KEEV
//
//  Created by Yune Cho on 11/22/24.
//

import Foundation

struct PaginatedResponse<T> {
    let totalPages: Int
    let currentPage: Int
    let totalElements: Int
    let contents: [T]
}
