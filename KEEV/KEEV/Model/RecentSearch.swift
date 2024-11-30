//
//  RecentSearch.swift
//  KEEV
//
//  Created by Doran on 11/3/24.
//

import Foundation

struct RecentSearch: Identifiable, Codable {
    var id = UUID()
    let term: String
    let date: Date
}
