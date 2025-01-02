//
//  NotficationCenter+Extension.swift
//  KEEV
//
//  Created by 김준성 on 1/2/25.
//

import Combine
import Foundation

extension NotificationCenter.Publisher {
    static let signInStatusPublisher: AnyPublisher<SignInStatus, Never> = {
        NotificationCenter.default.publisher(for: .updateSignInStatus)
            .map { $0.object as! SignInStatus }
            .eraseToAnyPublisher()
    }()
    
    static let userInfoPublisher: AnyPublisher<DetailUserUIO?, Never> = {
        NotificationCenter.default.publisher(for: .updateUserInfo)
            .map { $0.object as? DetailUserUIO }
            .eraseToAnyPublisher()
    }()
}

extension NSNotification.Name {
    static var updateSignInStatus: NSNotification.Name {
        return NSNotification.Name("updateSignInStatus")
    }
    
    static var updateUserInfo: NSNotification.Name {
        return NSNotification.Name("updateUserInfo")
    }
}
