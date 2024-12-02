//
//  EventFilter.swift
//  KEEV
//
//  Created by Doran on 12/2/24.
//

enum FilterType: String {
    case christmas = "christmas"
    case monthRock = "monthRock"
    case monthIndie = "monthIndie"
    case monthElectronic = "monthElectronic"
    case monthJazz = "monthJazz"
    case recent = "recent"
    
}

enum EventType: Int {
    case concert = 1
    case festival = 2
    case small = 3
    case club = 4
}

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

enum Mode: String {
    case event = "event"
    case reservation = "reservation"
}

struct EventFilter {
    var filterType: FilterType?
    var page: Int
    var size: Int
    var eventType: EventType?
    var genre: Genre?
    var startDate: String?
    var endDate: String?
    var mode: Mode
    var desc: Bool
    
    init(filterType: FilterType? = nil, page: Int = 0, size: Int = 7, eventType: EventType? = nil, genre: Genre? = nil, startDate: String? = nil, endDate: String? = nil, mode: Mode = .event, desc: Bool = true) {
        self.filterType = filterType
        self.page = page
        self.size = size
        self.eventType = eventType
        self.genre = genre
        self.startDate = startDate
        self.endDate = endDate
        self.mode = mode
        self.desc = desc
    }
    
    static func christmasFilter() -> EventFilter {
        return EventFilter(filterType: .christmas, startDate: "2024-12-23", endDate: "2024-12-27")
    }
    
    static func rockFilter() -> EventFilter {
        return EventFilter(filterType: .monthRock, genre: .rock, startDate: "2024-12-01", endDate: "2024-12-31")
    }
    
    static func indieFilter() -> EventFilter {
        return EventFilter(filterType: .monthIndie, genre: .indie, startDate: "2024-12-01", endDate: "2024-12-31")
    }
    
    static func electronicFilter() -> EventFilter {
        return EventFilter(filterType: .monthElectronic, genre: .electronic, startDate: "2024-12-01", endDate: "2024-12-31")
    }
    
    static func jazzFilter() -> EventFilter {
        return EventFilter(filterType: .monthJazz, genre: .jazz, startDate: "2024-12-01", endDate: "2024-12-31")
    }
    
    static func recentFilter() -> EventFilter {
        return EventFilter(filterType: .recent)
    }
}
