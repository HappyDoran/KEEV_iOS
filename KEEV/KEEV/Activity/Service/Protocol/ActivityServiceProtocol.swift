//
//  ActivityServiceProtocol.swift
//  KEEV
//
//  Created by Yune Cho on 11/26/24.
//

import Foundation

/// ActivityService를 구현하기 위한 프로토콜
///
/// ActivityService를 구현하기 위한 프로토콜입니다.
///
/// - Author: 라움
protocol ActivityServiceProtocol: AnyObject {
    func getUserInfo(userID: Int) async throws -> DetailUserUIO
    func getUserVibeList(userID: Int) async throws -> [VibeUIO]
}
