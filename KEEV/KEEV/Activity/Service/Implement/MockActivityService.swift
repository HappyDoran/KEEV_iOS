//
//  MockActivityService.swift
//  KEEV
//
//  Created by Yune Cho on 11/26/24.
//

import Foundation
import UIKit

/// MockActivityService
///
/// 서버와의 통신 없이 UI가 잘 나오는지 확인하기 위한 MockActivityService입니다.
///
/// - Author: 라움
class MockActivityService: ActivityServiceProtocol {
    func updateProfile(nickname: String, profileImage: UIImage?, backgroundImage: UIImage?, description: String) async throws -> DetailUserUIO {
        .dummy0
    }
    
    static let layer: LayerType = .service(of: "MockActivityService")
    
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
    
    func getUserLikedEvents(userID: Int, page: Int, size: Int, sort: [(SortCase, SortPattern)]) async throws -> PaginatedResponse<SimpleEventUIO> {
        var events: [SimpleEventUIO] = []
        let startIndex = page*size
        
        for index in startIndex..<startIndex + size {
            events.append(
                .init(id: "dummyID: \(index)", name: "Dummy Title: 이벤트\(index)", posterURL: SimpleEventUIO.dummy0.posterURL, dDay: Int.random(in: -10...10), startDate: "2024.12.05", endDate: "2024.12.05", placeName: "공연장\(index)", likedAt: "2024.11.01")
            )
        }
        
        return PaginatedResponse(totalPages: 5, currentPage: page, totalElements: 50, contents: events)
    }
    
    private enum ActivityServiceError: Error {
        case notFound
    }
}
