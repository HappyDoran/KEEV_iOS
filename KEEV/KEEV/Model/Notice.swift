//
//  Notice.swift
//  KEEV
//
//  Created by Yune Cho on 11/10/24.
//

import Foundation

struct Notice: Identifiable {
    var id: UUID = UUID()
    var title: String
    var date: Date
    var content: String
}
