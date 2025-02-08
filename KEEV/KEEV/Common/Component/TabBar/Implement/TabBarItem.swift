//
//  TabBarItem.swift
//  KEEV
//
//  Created by Doran on 11/8/24.
//

import SwiftUI

/// TabBar에 들어가는 아이템들을 정의하기 위한 열거형
///
///  아이템의 이름, 아이템 이미지, 아이템 라벨을 정의
///
/// - Author: Doran
enum TabbedItem: String, CaseIterable{
    case info = "info"
    case feed = "feed"
    case write = "write"
    case search = "search"
    case profile = "profile"
    
    /// - Note: 1.1.0 기준으로 탭바에서 title이 빠졌지만 나중에 필요할 수도 있을 것 같아서 일단 남겨놓겠습니다.
    /// - Author: 라움
    var title: String{
        switch self {
        case .info:
            return "홈"
        case .feed:
            return "피드"
        case .write:
            return "글쓰기"
        case .search:
            return "검색"
        case .profile:
            return "프로필"
        }
    }
    
    var iconName: String{
        switch self {
        case .info:
            return "house.fill"
        case .feed:
            return "text.rectangle.page.fill"
        case .write:
            return "plus.app"
        case .search:
            return "magnifyingglass"
        case .profile:
            return "person.fill"
        }
    }
    
    static func label(for item: TabbedItem) -> some View {
        Image(systemName: item.iconName)
            .environment(\.symbolVariants, .none)
    }
}
