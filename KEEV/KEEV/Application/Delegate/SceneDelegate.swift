//
//  SceneDelegate.swift
//  KEEV
//
//  Created by Yune Cho on 12/17/24.
//

import Foundation
import UIKit
import SwiftUI

/// 앱의 UI 생명주기를 관리하는 SceneDelegate
///
/// 앱의 UI 생명주기를 관리하는 SceneDelegate입니다.
///
/// - Author: 라움
class SceneDelegate: NSObject, UIWindowSceneDelegate {
    var window: UIWindow?
    @State private var appState = AppState()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UIHostingController(
            rootView: EntryView()
                .environment(appState)
                .modifier(AppState.Modifier(state: appState))
        )
        window?.makeKeyAndVisible()
    }
}
