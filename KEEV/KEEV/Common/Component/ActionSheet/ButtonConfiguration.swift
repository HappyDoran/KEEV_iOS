//
//  ButtonConfiguration.swift
//  KEEV
//
//  Created by 김준성 on 10/31/24.
//

import SwiftUI

extension KEEVActionSheet {
    enum ButtonConfiguration {
        case modify(title: String, action: () -> Void)
        case share(title: String, action: () -> Void)
        case delete(title: String, action: () -> Void)
        case report(title: String, action: () -> Void)
    }
}

extension KEEVActionSheet.ButtonConfiguration: KEEVButtonConfiguration {
    var title: String {
        switch self {
        case .modify(let title, _): return title
        case .share(let title, _): return title
        case .delete(let title, _): return title
        case .report(let title, _): return title
        }
    }
    
    var image: Image? {
        switch self {
        case .modify: Image(systemName: "pencil.line")
        case .share: Image(systemName: "square.and.arrow.up")
        case .delete: Image(systemName: "trash.fill")
        case .report: Image(systemName: "light.beacon.max.fill")
        }
    }
    
    var mainColor: Color {
        switch self {
        case .modify: fallthrough
        case .share: return .gray300
        case .delete: fallthrough
        case .report: return .red500
        }
    }
    
    var subColor: Color? { nil }
    
    var action: () -> Void {
        switch self {
        case .modify(_, let action): return action
        case .share(_, let action): return action
        case .delete(_, let action): return action
        case .report(_, let action): return action
        }
    }
}

extension Array where Element == KEEVActionSheet.ButtonConfiguration {
    typealias Configuration = KEEVActionSheet.ButtonConfiguration
    
    static func setProfileImage(
        modifyHandler: @escaping () -> Void,
        deleteHandler: @escaping () -> Void
    ) -> [Configuration] {
        [
            .modify(title: "사진 선택", action: modifyHandler),
            .delete(title: "프로필 사진 삭제", action: deleteHandler)
        ]
    }
    
    static func myVibe(
        modifyHandler: @escaping () -> Void,
        deleteHandler: @escaping () -> Void
    ) -> [Configuration] {
        [
            .modify(title: "바이브 수정하기", action: modifyHandler),
            .delete(title: "삭제하기", action: deleteHandler)
        ]
    }
    
    static func othersVibe(
        shareHandler: @escaping () -> Void,
        reportHandler: @escaping () -> Void
    ) -> [Configuration] {
        [
            .share(title: "공유하기", action: shareHandler),
            .report(title: "신고하기", action: reportHandler)
        ]
    }
    
    static func myComment(
        modifyHandler: @escaping () -> Void,
        deleteHandler: @escaping () -> Void
    ) -> [Configuration] {
        [
            .modify(title: "바이브 수정하기", action: modifyHandler),
            .delete(title: "삭제하기", action: deleteHandler)
        ]
    }
    
    static func othersComment(reportHandler: @escaping () -> Void) -> [Configuration] {
        [.report(title: "신고하기", action: reportHandler)]
    }
    
    static func concert(
        shareHandler: @escaping () -> Void,
        reportHandler: @escaping () -> Void
    ) -> [Configuration] {
        [
            .share(title: "공유하기", action: shareHandler),
            .report(title: "신고하기", action: reportHandler)
        ]
    }
}
