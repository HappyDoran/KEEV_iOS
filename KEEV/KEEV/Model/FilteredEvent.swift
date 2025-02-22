//
//  FilteredEvent.swift
//  KEEV
//
//  Created by Doran on 2/22/25.
//

enum Theme{
    case monthClub
    case monthIndie
    case monthJazz
    case recentEnd
    case upcoming
    case upcomingKR
    
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
    
    var url: String {
        switch self {
        case .monthClub:
            return "/open-api/event/this-month/club"
        case .monthIndie:
            return "/open-api/event/this-month/indie"
        case .monthJazz:
            return "/open-api/event/this-month/jazz"
        case .recentEnd:
            return "/open-api/event/recently-ended"
        case .upcoming:
            return "/open-api/event/upcoming"
        case .upcomingKR:
            return "/open-api/event/upcoming/international"
        }
    }
}
