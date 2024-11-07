//
//  ButtonConfiguration.swift
//  KEEV
//
//  Created by 김준성 on 10/31/24.
//

import SwiftUI

extension KEEVActionSheet {
    /// KEEVActionSheet에서 자주 사용되는 버튼 모양들을 모은 열거형
    ///
    /// - Parameters:
    ///     - title: 버튼의 이름입니다.
    ///     - action: 해당 버튼을 눌렀을 때 수행하는 함수입니다.
    ///
    /// ActionSheet에서 자주 쓰이는 버튼 모양들은 다음과 같습니다:
    /// - modify: 무언가를 수정할 때, 이미지는 SFSymbol의 pencil.line입니다.
    /// - share: 무언가를 공유할 때, 이미지는 SFSymbol의 square.and.arrow.up입니다.
    /// - delete: 무언가를 삭제할 때, 이미지는 SFSymbol의 trash.fill입니다.
    /// - report: 무언가를 신고, 보고할 때 이미지는 SFSymbol의 light.beacon.max.fill입니다.
    /// 
    /// - Author: newJunsung
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
    
    var action: @MainActor () -> Void {
        switch self {
        case .modify(_, let action): return action
        case .share(_, let action): return action
        case .delete(_, let action): return action
        case .report(_, let action): return action
        }
    }
}

extension Array where Element == KEEVActionSheet.ButtonConfiguration {
    
    /// 프로필 사진을 설정할 때 사용하는 액션시트의 프리셋
    ///
    /// - Parameters:
    ///   - modifyHandler: 사진 선택을 눌렀을 때 수행되는 함수.
    ///   - deleteHandler: 프로필 사진 삭제를 눌렀을 때 수행되는 함수
    ///
    /// - Returns: .modify(사진 선택)와 .delete(프로필 사진 삭제)로 구성된 배열
    /// - Author: newJunsung
    static func setProfileImage(
        modifyHandler: @escaping () -> Void,
        deleteHandler: @escaping () -> Void
    ) -> [Element] {
        [
            .modify(title: "사진 선택", action: modifyHandler),
            .delete(title: "프로필 사진 삭제", action: deleteHandler)
        ]
    }
    
    /// 프로필 배경사진을 설정할 때 사용하는 액션시트의 프리셋
    ///
    /// - Parameters:
    ///   - modifyHandler: 배경사진 선택을 눌렀을 때 수행되는 함수.
    ///   - deleteHandler: 배경사진 삭제를 눌렀을 때 수행되는 함수
    ///
    /// - Returns: .modify(배경사진 선택)와 .delete(배경사진 삭제)로 구성된 배열
    /// - Author: 라움
    static func setBackgroundImage(
        modifyHandler: @escaping () -> Void,
        deleteHandler: @escaping () -> Void
    ) -> [Element] {
        [
            .modify(title: "배경사진 선택", action: modifyHandler),
            .delete(title: "배경사진 삭제", action: deleteHandler)
        ]
    }
    
    /// 프로필 사진을 설정할 때 사용하는 액션시트의 프리셋
    ///
    /// - Parameters:
    ///   - modifyHandler: 바이브 수정하기 눌렀때 때 수행되는 함수.
    ///   - deleteHandler: 삭제하기를 눌렀을 때 수행되는 함수
    ///
    /// - Returns: .modify(바이브 수정하기)와 .delete(삭제하기)로 구성된 배열
    /// - Author: newJunsung
    static func myVibe(
        modifyHandler: @escaping () -> Void,
        deleteHandler: @escaping () -> Void
    ) -> [Element] {
        [
            .modify(title: "바이브 수정하기", action: modifyHandler),
            .delete(title: "삭제하기", action: deleteHandler)
        ]
    }
    
    /// 프로필 사진을 설정할 때 사용하는 액션시트의 프리셋
    ///
    /// - Parameters:
    ///   - shareHandler: 공유하기를 눌렀을 때 수행되는 함수.
    ///   - reportHandler: 신고하기를 눌렀을 때 수행되는 함수
    ///
    /// - Returns: .share(공유하기)와 .report(신고하기)로 구성된 배열
    /// - Author: newJunsung
    static func othersVibe(
        shareHandler: @escaping () -> Void,
        reportHandler: @escaping () -> Void
    ) -> [Element] {
        [
            .share(title: "공유하기", action: shareHandler),
            .report(title: "신고하기", action: reportHandler)
        ]
    }
    
    /// 프로필 사진을 설정할 때 사용하는 액션시트의 프리셋
    ///
    /// - Parameters:
    ///   - modifyHandler: 댓글 수정하기를 눌렀을 때 수행되는 함수.
    ///   - deleteHandler: 삭제하기를 눌렀을 때 수행되는 함수
    ///
    /// - Returns: .modify(댓글 수정하기)와 .delete(삭제하기)로 구성된 배열
    /// - Author: newJunsung
    static func myComment(
        modifyHandler: @escaping () -> Void,
        deleteHandler: @escaping () -> Void
    ) -> [Element] {
        [
            .modify(title: "댓글 수정하기", action: modifyHandler),
            .delete(title: "삭제하기", action: deleteHandler)
        ]
    }
    
    /// 프로필 사진을 설정할 때 사용하는 액션시트의 프리셋
    ///
    /// - Parameters:
    ///   - reportHandler: 신고하기를 눌렀을 때 수행되는 함수.
    ///
    /// - Returns: .report(신고하기)로 구성된 배열
    /// - Author: newJunsung
    static func othersComment(
        reportHandler: @escaping () -> Void
    ) -> [Element] {
        [.report(title: "신고하기", action: reportHandler)]
    }
    
    /// 프로필 사진을 설정할 때 사용하는 액션시트의 프리셋
    ///
    /// - Parameters:
    ///   - shareHandler: 공유하기를 눌렀을 때 수행되는 함수.
    ///   - reportHandler: 신고하기를 눌렀을 때 수행되는 함수
    ///
    /// - Returns: .share(공유하기)와 .report(신고하기)로 구성된 배열
    /// - Author: newJunsung
    static func concert(
        shareHandler: @escaping () -> Void,
        reportHandler: @escaping () -> Void
    ) -> [Element] {
        [
            .share(title: "공유하기", action: shareHandler),
            .report(title: "신고하기", action: reportHandler)
        ]
    }
}
