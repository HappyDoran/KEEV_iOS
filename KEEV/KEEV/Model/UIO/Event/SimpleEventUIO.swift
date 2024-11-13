//
//  SimpleEventUI.swift
//  KEEV
//
//  Created by 김준성 on 11/13/24.
//

import Foundation

struct SimpleEventUIO: Identifiable {
    let id: String
    let name: String
    let dDay: Int?
    let startDate: String
    let endDate: String
    let placeName: String
    
    init(id: String, name: String, dDay: Int, startDate: String, endDate: String, placeName: String) {
        self.id = id
        self.name = name
        self.dDay = dDay
        self.startDate = startDate
        self.endDate = endDate
        self.placeName = placeName
    }
    
    init(simpleEventDTO event: SimpleEventDTO) {
        let dateFormat = "yyyy. MM. dd"
        
        self.id = event.id
        self.name = event.name
        self.dDay = event.startDate.difference(from: .now)
        self.startDate = event.startDate.toString(format: dateFormat)
        self.endDate = event.endDate.toString(format: dateFormat)
        self.placeName = event.placeName
    }
    
    init(detailEventDTO event: DetailEventDTO) {
        let dateFormat = "yyyy. MM. dd"
        
        self.id = event.id
        self.name = event.name
        self.dDay = event.startDate.difference(from: .now)
        self.startDate = event.startDate.toString(format: dateFormat)
        self.endDate = event.endDate.toString(format: dateFormat)
        self.placeName = event.place.name
    }
}

extension SimpleEventUIO {
    static let dummy0 = SimpleEventUIO(simpleEventDTO: .dummy0)
    static let dummy1 = SimpleEventUIO(simpleEventDTO: .dummy1)
    static let dummy2 = SimpleEventUIO(simpleEventDTO: .dummy2)
    static let dummy3 = SimpleEventUIO(simpleEventDTO: .dummy3)
    static let dummy4 = SimpleEventUIO(simpleEventDTO: .dummy4)
    static let dummy5 = SimpleEventUIO(simpleEventDTO: .dummy5)
    static let dummy6 = SimpleEventUIO(simpleEventDTO: .dummy6)
    static let dummy7 = SimpleEventUIO(simpleEventDTO: .dummy7)
    static let dummy8 = SimpleEventUIO(simpleEventDTO: .dummy8)
    static let dummy9 = SimpleEventUIO(simpleEventDTO: .dummy9)
    
    static let dummies = SimpleEventDTO.dummies.map(SimpleEventUIO.init)
}
