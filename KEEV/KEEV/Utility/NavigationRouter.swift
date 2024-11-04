//
//  NavigationRouter.swift
//  KEEV
//
//  Created by Yune Cho on 10/17/24.
//

import Foundation
import SwiftUI

/// 뷰의 전환을 담당하는 NavigationRouter
///
/// 뷰의 전환을 담당하는 NavigationRouter이며 ObservableObject로 구현하였습니다.
///
/// - Note: 뷰에서 EnvironmentObject로 사용합니다.
/// - Author: 라움
class NavigationRouter: ObservableObject {
    /// 경로에 항목을 추가하거나 제거하는 등의 조작이 가능한 네비게이션 스택의 내용을 나타내는 데이터 타입
    @Published var path: NavigationPath = NavigationPath()

    /// destination들을 포함하고 있는 열거형
    ///
    /// NavigationRouter에서 가능한 destination들을 포함하고 있는 열거형입니다.
    ///
    /// - Note: 뷰 작업 완료되면 case 추가해줘야 합니다.
    /// - Author: 라움
    enum Route {
        case dummyScreen
        case dummyView
    }

    /// 뷰를 빌드해주는 ViewBuilder 함수
    ///
    /// - Parameters:
    ///   - route: Route 열거형 값
    ///
    /// 인자로 받은 Route 열거형의 값에 따라서 뷰를 만들어주는 ViewBuiler 함수입니다.
    ///
    /// - Returns: route 값에 따른 View를 리턴합니다.
    ///
    /// - Note: 뷰 작업 완료되면 case 추가해줘야 합니다.
    /// - Author: 라움
    @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
        case .dummyScreen:
            DummyScreen()
        case .dummyView:
            DummyView()
        }
    }

    /// path 스택에 Route를 넣는 push 함수
    ///
    /// - Parameters:
    ///   - route: 새롭게 보여줄 뷰에 해당하는 Route 열거형의 값
    ///
    /// path 스택에 Route를 넣는 push 함수입니다.
    /// 다른 뷰로 navigate해주는 역할을 합니다.
    ///
    /// - Author: 라움
    func push(_ route: Route) {
        path.append(route)
    }

    /// path 스택 최상단에 있는 Route를 빼는 pop 함수
    ///
    /// path 스택 최상단에 있는 Route를 빼는 pop 함수입니다.
    /// 이전 뷰로 돌아가는 역할을 합니다.
    ///
    /// - Author: 라움
    func pop() {
        path.removeLast()
    }

    /// path 스택에 있는 모든 Route를 빼는 popToRoot 함수
    ///
    /// path 스택에 있는 모든 Route를 빼는 popToRoot 함수입니다.
    /// 루트뷰로 돌아가는 역할을 합니다.
    ///
    /// - Author: 라움
    func popToRoot() {
        path.removeLast(path.count)
    }
}
