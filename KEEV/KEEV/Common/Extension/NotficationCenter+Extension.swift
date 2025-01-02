//
//  NotficationCenter+Extension.swift
//  KEEV
//
//  Created by 김준성 on 1/2/25.
//

import Foundation

extension NSNotification.Name {
    static var updateSignInStatus: NSNotification.Name {
        return NSNotification.Name("updateSignInStatus")
    }
    
    static var updateUserInfo: NSNotification.Name {
        return NSNotification.Name("updateUserInfo")
    }
}
