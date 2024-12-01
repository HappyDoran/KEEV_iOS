//
//  RecentSearch.swift
//  KEEV
//
//  Created by Doran on 11/3/24.
//

import Foundation

struct RecentSearch: Identifiable, Codable {
    let id = UUID()
    let term: String
    let date: Date
}
