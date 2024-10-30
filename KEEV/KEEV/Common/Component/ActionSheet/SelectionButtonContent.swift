//
//  SelectionButtonContent.swift
//  KEEV
//
//  Created by Yune Cho on 10/30/24.
//

import Foundation

/// 액션 시트 버튼 동작 종류에 대한 Symbol Image 이름을 담고 있는 열거형
///
/// 액션 시트 버튼 동작 종류에 대한 Symbol Image 이름을 담고 있는 열거형입니다.
///
/// - Note: 버튼 동작과 Symbol Image가 추가될 경우 여기에 추가바랍니다.
/// - Author: 라움
enum SelectionButtonType: String {
    case modify = "pencil.line"
    case delete = "trash.fill"
    case share = "square.and.arrow.up"
    case report = "light.beacon.max.fill"
}

/// 액션 시트 버튼에 표시할 정보를 담고 있는 구조체
///
/// 액션 시트 버튼에 표시할 정보를 담고 있는 구조체입니다. 담고 있는 정보는 다음과 같습니다.
///
/// id - 버튼의 title 내용을 id로 가지고 있습니다. ForEach로 화면에 보여주기 위해서 필요한 정보입니다.
///
/// type - 버튼의 동작 종류를 case 별로 담고 있고 각 종류에 대한 Symbol Image 정보를 rawValue로 가지고 있습니다.
///
/// title - 버튼에 표시할 타이틀입니다.
///
/// action - 버튼을 탭했을 경우 수행할 동작입니다.
///
/// - Author: 라움
struct SelectionButtonContent: Identifiable {
    var id: String { title }
    let type: SelectionButtonType
    let title: String
    let action: (() -> Void)
    
    init(type: SelectionButtonType, title: String, action: @escaping () -> Void) {
        self.type = type
        self.title = title
        self.action = action
    }
}
