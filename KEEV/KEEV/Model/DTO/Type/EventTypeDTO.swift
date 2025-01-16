//
//  EventTypeDTO.swift
//  KEEV
//
//  Created by Doran on 11/28/24.
//

struct EventTypeDTO: Decodable, Hashable, Identifiable {
    let id: Int
    let name: String
}
