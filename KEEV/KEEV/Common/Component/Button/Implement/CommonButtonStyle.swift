//
//  CommonButtonStyle.swift
//  KEEV
//
//  Created by Doran on 10/23/24.
//

import SwiftUI


/// 프로젝트에서 전반적으로 사용되는 버튼들을 정의하기 위한 열거형
///
/// `submit`의 경우에는 `isEnabled(버튼의 활성화 상태)` 라는 bool타입 상수를 통해서 backgroundColor, foregroundColor 상태가 달라집니다.
///
/// `alert`의 경우에는 `isPositive(확인과 취소의 구분)` 라는 bool타입 상수를 통해서 backgroundColor 상태가 달라집니다.
///
/// - Author: Doran
enum CommonButtonStyle {
    // maxWidth 버튼 ex) 확인 버튼
    case maxWidth
    // alert에서 사용되는 버튼
    case alert(isPositive: Bool)
    // width가 174인 버튼 ex) 공연등록 요청하기 버튼
    case small
    // width가 179인 버튼 ex) 지금 기록하러 가기 버튼
    case medium
    // 비활성화 버튼
    case disabled

    // brandColor600 - gray
    // grayColor100 - red
    // grayColor500 - blue
    // grayColor900 - purple
    
    // MARK: 배경 색
    var backgroundColor: Color {
        switch self {
        case .maxWidth:
            return .purple
        case .alert(let isPositive):
            return isPositive ? .gray : .blue
        case .small, .medium:
            return .gray
        default:
            return .gray
        }
    }
    
    // MARK: 텍스트 색
    var foregroundColor: Color {
        switch self {
        case .maxWidth:
            return .blue
        case .alert, .small, .medium:
            return .red
        default:
            return .red
        }
    }
    
    // MARK: 가로로 긴 버튼은 maxWidth 지정
    var maxWidth: CGFloat? {
        switch self {
        case .maxWidth:
            return .infinity
        case .alert, .small, .medium:
            return nil
        default:
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
        default:
            return 48
        }
    }
}

