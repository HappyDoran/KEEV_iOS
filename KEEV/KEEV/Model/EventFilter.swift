//
//  EventFilter.swift
//  KEEV
//
//  Created by Doran on 12/2/24.
//

import Foundation

/// 필터링된 이벤트를 보여주기 위한 필터 조건중 하나인 이벤트 타입 열거형
///
/// - Author: Doran
enum EventType: Int {
    case concert = 1
    case festival = 2
    case small = 3
    case club = 4
}

/// 필터링된 이벤트를 보여주기 위한 필터 조건중 하나인 이벤트 장르 열거형
///
/// - Author: Doran
enum Genre: Int {
    case pop = 1
    case rock = 2
    case indie = 3
    case hiphop = 4
    case electronic = 5
    case kPop = 6
    case jazz = 7
    case classic = 8
    case jPop = 9
    case rnB = 10
    case ballad = 11
}

/// 필터링된 이벤트를 보여주기 위한 필터 조건중 하나인 이벤트 모드 열거형
///
/// - Author: Doran
enum Mode: String {
    case event = "event"
    case reservation = "reservation"
}

/// 이벤트 필터링 구조체
///
/// 각각의 상황에 맞게 생성하고 필터에 맞는 인스턴스를 생성합니다.
///
/// - Author: Doran
struct EventFilter: Equatable {
    var page: Int
    var size: Int
    var eventType: EventType?
    var genre: Genre?
    var startDate: String?
    var endDate: String?
    var mode: Mode
    var desc: Bool
    
    init(page: Int = 0, size: Int = 7, eventType: EventType? = nil, genre: Genre? = nil, startDate: String? = nil, endDate: String? = nil, mode: Mode = .event, desc: Bool = true) {
        self.page = page
        self.size = size
        self.eventType = eventType
        self.genre = genre
        self.startDate = startDate
        self.endDate = endDate
        self.mode = mode
        self.desc = desc
    }
    
    init(eventFilter: EventFilter, page: Int, size: Int){
        self.page = page
        self.size = size
        self.eventType = eventFilter.eventType
        self.genre = eventFilter.genre
        self.startDate = eventFilter.startDate
        self.endDate = eventFilter.endDate
        self.mode = eventFilter.mode
        self.desc = eventFilter.desc
    }
    
    static var upCommingFilter: EventFilter {
        let today = Date()
        let endDate = Calendar.current.date(byAdding: .day, value: 30, to: today)!
        
        return EventFilter(startDate: today.toString(format: "yyyy-MM-dd"), endDate: endDate.toString(format: "yyyy-MM-dd"), desc: false)
    }
    
    static var rockFilter: EventFilter {
        return EventFilter(genre: .rock, startDate: "2025-01-01", endDate: "2025-02-28")
    }
    
    static var smallPerformFilter: EventFilter {
        return EventFilter(eventType: .small, startDate: "2025-01-01", endDate: "2025-02-28")
    }
    
    static var hiphopFilter: EventFilter {
        return EventFilter(genre: .hiphop, startDate: "2025-01-01", endDate: "2025-02-28")
    }
}
