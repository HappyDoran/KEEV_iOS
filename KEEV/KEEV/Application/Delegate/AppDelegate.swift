//
//  AppDelegate.swift
//  KEEV
//
//  Created by Yune Cho on 12/17/24.
//

import Foundation
import UIKit

import Firebase

/// 앱의 전반적인 생명주기와 앱 수준의 이벤트를 관리하는 AppDelegate
///
/// 앱의 전반적인 생명주기와 앱 수준의 이벤트를 관리하는 AppDelegate입니다.
///
/// - Author: 라움
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}
