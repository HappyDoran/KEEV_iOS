//
//  FilteredEvent.swift
//  KEEV
//
//  Created by Doran on 2/22/25.
//

import SwiftUI

enum FilterTheme{
    case monthClub
    case monthIndie
    case monthJazz
    case recentEnd
    case upcoming
    case upcomingKR
}

extension FilterTheme {
    var title: String{
        switch self {
        case .monthClub:
            return "이달의 클럽 공연"
        case .monthIndie:
            return "이달의 인디 공연"
        case .monthJazz:
            return "이달의 재즈 공연"
        case .recentEnd:
            return "최근에 끝난 공연"
        case .upcoming:
            return "다가오는 공연"
        case .upcomingKR:
            return "다가오는 내한공연 예약일"
        }
    }
    
    var path: [String]? {
        var path = ["open-api", "event"]
        
        switch self {
        case .monthClub:
            path.append(contentsOf: ["this-month", "club"])
        case .monthIndie:
            path.append(contentsOf: ["this-month", "indie"])
        case .monthJazz:
            path.append(contentsOf: ["this-month", "jazz"])
        case .recentEnd:
            path.append(contentsOf: ["recently-ended"])
        case .upcoming:
            path.append(contentsOf: ["upcoming"])
        case .upcomingKR:
            path.append(contentsOf: ["upcoming", "international"])
        }
        return path
    }
}

