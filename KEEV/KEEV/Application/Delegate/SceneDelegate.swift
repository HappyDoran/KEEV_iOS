//
//  SceneDelegate.swift
//  KEEV
//
//  Created by Yune Cho on 12/17/24.
//

import Foundation
import UIKit
import SwiftUI

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UIHostingController(rootView: EntryView().environmentObject(VibeManager()))
        window?.makeKeyAndVisible()
    }
}
