//
//  TabBarItem.swift
//  KEEV
//
//  Created by Doran on 11/8/24.
//

enum TabbedItem: String, CaseIterable{
    case info = "info"
    case write = "write"
    case profile = "profile"
    
    var title: String{
        switch self {
        case .info:
            return "정보"
        case .write:
            return "글쓰기"
        case .profile:
            return "프로필"
        }
    }
    
    var iconName: String{
        switch self {
        case .info:
            return "newspaper.fill"
        case .write:
            return "plus.app"
        case .profile:
            return "person.fill"
        }
    }
}
