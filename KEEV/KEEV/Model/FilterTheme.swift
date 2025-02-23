//
//  FilteredEvent.swift
//  KEEV
//
//  Created by Doran on 2/22/25.
//

import SwiftUI

enum FilterTheme: CaseIterable{
    case monthlyClub
    case monthlyIndie
    case monthlyJazz
    case recentlyFinished
    case upcoming
    case upcomingInKorReservation
}

extension FilterTheme {
    var title: String{
        switch self {
        case .monthlyClub:
            return "이달의 클럽 공연"
        case .monthlyIndie:
            return "이달의 인디 공연"
        case .monthlyJazz:
            return "이달의 재즈 공연"
        case .recentlyFinished:
            return "최근에 끝난 공연"
        case .upcoming:
            return "다가오는 공연"
        case .upcomingInKorReservation:
            return "다가오는 내한공연 예약일"
        }
    }
    
    var path: [String]? {
        var path = ["open-api", "event"]
        
        switch self {
        case .monthlyClub:
            path.append(contentsOf: ["this-month", "club"])
        case .monthlyIndie:
            path.append(contentsOf: ["this-month", "indie"])
        case .monthlyJazz:
            path.append(contentsOf: ["this-month", "jazz"])
        case .recentlyFinished:
            path.append(contentsOf: ["recently-ended"])
        case .upcoming:
            path.append(contentsOf: ["upcoming"])
        case .upcomingInKorReservation:
            path.append(contentsOf: ["upcoming", "international"])
        }
        return path
    }
}

