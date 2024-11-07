//
//  CommonButtonStyle.swift
//  KEEV
//
//  Created by Doran on 10/23/24.
//

import SwiftUI

/// 프로젝트에서 전반적으로 사용되는 버튼들을 정의하기 위한 열거형
///
/// `alert`의 경우에는 `type(알럿 버튼 타입)`이라는 AlertButtonStyle 타입 상수를 통해서 backgroundColor 상태가 달라집니다.
///
/// - Author: Doran
enum CommonButtonStyle {
    // maxWidth 버튼 ex) 확인 버튼
    case maxWidth
    // alert에서 사용되는 버튼
    case alert(type: AlertButtonStyle)
    // width가 174인 버튼 ex) 공연등록 요청하기 버튼
    case small
    // width가 179인 버튼 ex) 지금 기록하러 가기 버튼
    case medium

    // MARK: 배경 색
    var backgroundColor: Color {
        switch self {
        case .maxWidth:
            return .brand600
        case .alert(let type):
            switch type {
            case .normal:
                return .gray500
            case .active:
                return .brand500
            case .destructive:
                return .red500
            }
        case .small, .medium:
            return .brand600
        }
    }
    
    // MARK: 텍스트 색
    var foregroundColor: Color {
        switch self {
        case .maxWidth:
            return .gray100
        case .alert, .small, .medium:
            return .gray100
        }
    }
    
    // MARK: 가로로 긴 버튼은 maxWidth 지정
    var maxWidth: CGFloat? {
        switch self {
        case .maxWidth, .alert:
            return .infinity
        case .small, .medium:
            return nil
        }
    }
    
    // MARK: 가로 길이
    var width: CGFloat {
        switch self {
        case .alert:
            return 131
        case .small:
            return 174
        case .medium:
            return 179
        default:
            return 355
        }
    }
    
    // MARK: 세로 길이
    var height: CGFloat {
        switch self {
        case .maxWidth:
            return 56
        case .alert:
            return 45
        case .small, .medium:
            return 48
        }
    }
}

/// alert에서 사용되는 버튼의 스타일 타입
///
/// 아래와 같이 세가지 타입이 있습니다.
///
/// normal : 회색 버튼으로 일반적인 버튼
///
/// active : 보라색 버튼으로 활성상태의 버튼
///
/// destructive : 빨간색 버튼으로 주의를 필요로 하는 버튼
///
/// - Author: 라움
enum AlertButtonStyle {
    /// 회색 버튼으로 일반적인 버튼
    case normal
    /// 보라색 버튼으로 활성상태의 버튼
    case active
    /// 빨간색 버튼으로 주의를 필요로 하는 버튼
    case destructive
}
