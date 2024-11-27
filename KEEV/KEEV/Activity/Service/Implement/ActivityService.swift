//
//  ActivityService.swift
//  KEEV
//
//  Created by Yune Cho on 11/28/24.
//

import Foundation

/// 사용자가 서비스를 사용하면서 수행한 액티비티를 위한 ActivityService
///
/// 사용자가 서비스를 사용하면서 수행한 액태비티를 위한 ActivityService입니다.
///
/// - Author: 라움
class ActivityService: ActivityServiceProtocol {
    private let networkUtility = NetworkUtility()
    private let jsonDecoder = JSONDecoder()
    
    func getUserInfo(userID: Int) async throws -> DetailUserUIO {
        let router = ActivityHTTPRequestRouter.userInfo(userID: userID)
        
        let data = try await networkUtility.request(router: router)
        
        let response = try jsonDecoder.decode(DetailUserDTO.self, from: data)
        
        let detailUserUIO = DetailUserUIO(detailuserDTO: response)
        
        return detailUserUIO
    }
    
    func getUserVibeList(userID: Int) async throws -> [VibeUIO] {
        let router = ActivityHTTPRequestRouter.userVibeList(userID: userID)
        
        let data = try await networkUtility.request(router: router)
        
        let response = try jsonDecoder.decode([VibeDTO].self, from: data)
        
        let vibeUIOs = response.compactMap { VibeUIO(vibeDTO: $0, isMine: $0.user.id == userID ? true : false) }
        
        return vibeUIOs
    }
}
