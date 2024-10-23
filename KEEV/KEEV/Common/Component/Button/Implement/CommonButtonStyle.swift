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
    // 확인 버튼
    case submit(isEnabled: Bool)
    // alert에서 사용되는 버튼
    case alert(isPositive: Bool)
    // 기록하러 가기 버튼
    case goToRecord
    // 공연 등록 요청하기 버튼
    case request

    // brandColor600 - gray
    // grayColor100 - red
    // grayColor500 - blue
    // grayColor900 - purple
    
    // MARK: 배경 색
    var backgroundColor: Color {
        switch self {
        case .submit(let isEnabled):
            return isEnabled ? .gray : .purple
        case .alert(let isPositive):
            return isPositive ? .gray : .blue
        case .goToRecord, .request:
            return .gray
        }
    }
    
    // MARK: 텍스트 색
    var foregroundColor: Color {
        switch self {
        case .submit(let isEnabled):
            return isEnabled ? .red : .blue
        case .alert:
            return .red
        case .goToRecord, .request:
            return .red
        }
    }
    
    // MARK: 가로로 긴 버튼은 maxWidth 지정
    var maxWidth: CGFloat? {
        switch self {
        case .submit:
            return .infinity
        case .alert, .goToRecord, .request:
            return nil
        }
    }
    
    // MARK: 가로 길이
    var width: CGFloat {
        switch self {
        case .alert:
            return 131
        case .goToRecord:
            return 179
        case .request:
            return 174
        default:
            return 355
        }
    }
    
    // MARK: 세로 길이
    var height: CGFloat {
        switch self {
        case .submit:
            return 56
        case .alert:
            return 45
        case .goToRecord, .request:
            return 48
        }
    }
}
