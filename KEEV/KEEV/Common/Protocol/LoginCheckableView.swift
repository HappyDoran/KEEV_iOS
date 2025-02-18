//
//  LoginCheckableView.swift
//  KEEV
//
//  Created by 김준성 on 2/17/25.
//

import SwiftUI

@MainActor
protocol LoginCheckableView: View {
    var appState: AppState { get }
}

extension LoginCheckableView {
    func checkLoginBefore(_ handler: () -> Void) {
        if appState.checkLoginStatus() {
            handler()
        }
    }
}
