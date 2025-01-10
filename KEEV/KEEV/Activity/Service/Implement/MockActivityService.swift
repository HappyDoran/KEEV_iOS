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
    static var layer: LayerType = .service(of: "MockActivityService")
    
    func getUserInfo(userID: Int) async throws -> DetailUserUIO {
        for dummy in DetailUserUIO.dummies {
            if dummy.id == userID {
                return dummy
            }
        }
        throw ActivityServiceError.notFound
    }
    
    func getUserVibeList(userID: Int) async throws -> [VibeUIO] {
        var vibes: [VibeUIO] = []
        
        for dummy in VibeUIO.dummies {
            vibes.append(dummy)
        }
        
        return vibes
    }
    
    private enum ActivityServiceError: Error {
        case notFound
    }
}
