//
//  TempVibeServiceProtocol.swift
//  KEEV
//
//  Created by Yune Cho on 11/24/24.
//

import Foundation
import SwiftUI

/// VibeService를 구현하기 위한 프로토콜
///
/// VibeService를 구현하기 위한 프로토콜입니다.
///
/// - ToDo: 향후에 VibeServiceProtocol을 이 TempVibeServiceProtocol로 교체해야합니다.
/// - Author: 라움
protocol TempVibeServiceProtocol: AnyObject {
    func getPaginatedVibes(page: Int, size: Int, sort: String) async throws -> PaginatedResponse<VibeUIO>
    func getVibeCount(eventID: String) async throws -> Int
    func uploadVibe(rating: Float, comment: String?, images: [Image]?) async throws -> VibeUIO
    func deleteVibe(eventID: String, vibeID: Int) async throws
    func modifyVibe(vibeID: Int, rating: Double, comment: String?, previousImageURLs: [String], images: [Image]?) async throws -> VibeUIO
    func checkIfUserUploadedVibe(userID: Int) async throws -> Int
    func getVibeWithVibeID(vibeID: Int) async throws -> VibeUIO
}
