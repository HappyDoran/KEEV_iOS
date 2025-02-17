//
//  AppState.swift
//  KEEV
//
//  Created by 김준성 on 2/11/25.
//

import Observation
import SwiftUI

@Observable
@MainActor
final class AppState {
    private(set) var toast: Toast? = nil
    private(set) var alert: Alert? = nil
    private(set) var actionSheet: [any KEEVButtonConfiguration]? = nil
    private(set) var loginStatus: SignInStatus? = nil
    
    fileprivate var needToLogin: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        bind()
    }
    
    private func bind() {
        NotificationCenter.Publisher
            .signInStatusPublisher
            .sink { [weak self] in
                self?.loginStatus = $0
                print("fefewaf: \($0)")
            }
            .store(in: &cancellables)
    }
    
    func presentToast(_ toast: Toast) {
        self.toast = toast
    }
    
    func presentAlert(_ alert: Alert) {
        self.alert = alert
    }
    
    func presentError(_ error: Error) {
        alert = .init(
            title: "오류",
            firstButtonText: (error.localizedDescription),
            firstButtonStyle: .active,
            firstButtonAction: {}
        )
    }
    
    func presentActionSheet(_ actionSheet: [any KEEVButtonConfiguration]) {
        self.actionSheet = actionSheet
    }
    
    func presentActionSheet(defaults: [KEEVActionSheet.ButtonConfiguration]) {
        self.actionSheet = defaults
    }
}

extension AppState {
    struct Alert {
        let title: String
        let message: String?
        
        let firstButtonText: String
        let firstButtonStyle: AlertButtonStyle
        let firstButtonAction: () -> Void
        
        let secondButtonText: String?
        let secondButtonStyle: AlertButtonStyle?
        let secondButtonAction: (() -> Void)?
        
        init(
            title: String,
            message: String? = nil,
            firstButtonText: String,
            firstButtonStyle: AlertButtonStyle,
            firstButtonAction: @escaping () -> Void,
            secondButtonText: String? = nil,
            secondButtonStyle: AlertButtonStyle? = nil,
            secondButtonAction: (() -> Void)? = nil
        ) {
            self.title = title
            self.message = message
            self.firstButtonText = firstButtonText
            self.firstButtonStyle = firstButtonStyle
            self.firstButtonAction = firstButtonAction
            self.secondButtonText = secondButtonText
            self.secondButtonStyle = secondButtonStyle
            self.secondButtonAction = secondButtonAction
        }
    }
}

extension AppState {
    struct Modifier: ViewModifier {
        @Bindable var state: AppState
        
        func body(content: Content) -> some View {
            content
                .backgroundForKEEV()
                .modifier(Toast.Modifier(toast: $state.toast, duration: .seconds(of: 2)))
                .modifier(CustomAlertViewModifier($state.alert))
                .modifier(KEEVActionSheet.Modifier(configurations: $state.actionSheet))
            
        }
    }
}
