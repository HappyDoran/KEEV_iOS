//
//  SelectionButtonPreset.swift
//  KEEV
//
//  Created by Yune Cho on 10/30/24.
//

import Foundation

/// 액션 시트 버튼 프리셋
///
/// 액션 시트의 종류에 따라 노출되는 버튼을 미리 설정해놓은 프리셋입니다.
///
/// 액션 시트가 나오는 상황 별로 case를 설정하였고 각 case 별로 노출되는 버튼의 종류를 함수에서 리턴하도록 구현했습니다.
///
/// - Note: 액션 시트가 추가되거나 버튼이 추가될 경우 이 프리셋에서 설정해주시면 됩니다.
/// - Author: 라움
enum SelectionButtonPreset {
    case setProfileImage
    case myVibe
    case othersVibe
    case myComment
    case othersComment
    case concert
    case custom([SelectionButtonContent])
    
    // 지금 현재 각 프리셋 버튼들의 기능이 들어갈 클로저는 비어있는 상태입니다. 기능 추가될시 클로저에 기능 추가 바랍니다.
    func buttons() -> [SelectionButtonContent] {
        switch self {
        case .setProfileImage:
            return [SelectionButtonContent(type: .modify, title: "사진 선택") { },
                    SelectionButtonContent(type: .delete, title: "프로필 사진 삭제") { }]
        case .myVibe:
            return [SelectionButtonContent(type: .modify, title: "바이브 수정하기") { },
                    SelectionButtonContent(type: .delete, title: "삭제하기") { }]
        case .othersVibe:
            return [SelectionButtonContent(type: .share, title: "공유하기") { },
                    SelectionButtonContent(type: .report, title: "신고하기") { }]
        case .myComment:
            return [SelectionButtonContent(type: .modify, title: "댓글 수정하기") { },
                    SelectionButtonContent(type: .delete, title: "삭제하기") { }]
        case .othersComment:
            return [SelectionButtonContent(type: .report, title: "신고하기") { }]
        case .concert:
            return [SelectionButtonContent(type: .share, title: "공유하기") { },
                    SelectionButtonContent(type: .report, title: "신고하기") { }]
        case .custom(let customButtons):
            return customButtons
        }
    }
}
