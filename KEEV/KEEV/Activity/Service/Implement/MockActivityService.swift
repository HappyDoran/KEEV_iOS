//
//  MockActivityService.swift
//  KEEV
//
//  Created by Yune Cho on 11/26/24.
//

import Foundation

/// MockActivityService
///
/// 서버와의 통신 없이 UI가 잘 나오는지 확인하기 위한 MockActivityService입니다.
///
/// - Author: 라움
class MockActivityService: ActivityServiceProtocol {
    func getUserInfo(userID: Int) async throws -> DetailUserUIO {
        DetailUserUIO(id: 1, nickname: "가래떡강아지", profileImageURL: nil, backgroundImageURL: nil, description: nil)
    }
    
    func getUserVibeList(userID: Int) async throws -> [VibeUIO] {
        var vibes: [VibeUIO] = []
        
        for dummy in VibeUIO.dummies {
            vibes.append(dummy)
        }
        
        return vibes
    }
}
