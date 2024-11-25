//
//  MockVibeService.swift
//  KEEV
//
//  Created by Yune Cho on 11/25/24.
//

import Foundation
import SwiftUI

/// MockVibeService
///
/// 서버와의 통신 없이 UI가 잘 나오는지 확인하기 위한 MockVibeService입니다.
///
/// - Todo: 향후에 VibeService와 VibeServiceProtocol을 교체하면서 MockService의 프로토콜도 수정해주어야합니다.
/// - Author: 라움
class MockVibeService: TempVibeServiceProtocol {
    func getPaginatedVibes(page: Int, size: Int, sort: String) async throws -> PaginatedResponse<VibeUIO> {
        var vibes: [VibeUIO] = []
        let startIndex = page*size
        
        for index in startIndex..<startIndex + size {
            vibes.append(
                .init(
                    id: index,
                    user: SimpleUserUIO(id: index, nickname: "더미닉네임\(index)", profileImageURL: nil),
                    event: SimpleEventUIO(id: "dummyID: \(index)", name: "Dummy Title: 이벤트\(index)", posterURL: nil, dDay: 7, startDate: "2024.12.05", endDate: "2024.12.05", placeName: "공연장\(index)"),
                    rating: 3.5,
                    imageURLs: [nil],
                    comment: "코멘트 내용\(index)",
                    createdDate: "2024.11.25",
                    likeCount: index,
                    replyCount: index
                )
            )
        }
        
        if vibes.isEmpty {
            throw VibeError.notFound
        } else {
            return PaginatedResponse(totalPages: 5, currentPage: page, totalElements: 50, contents: vibes)
        }
    }
    
    func getVibeCount(eventID: String) async throws -> Int {
        1
    }
    
    func uploadVibe(rating: Float, comment: String?, images: [Image]?) async throws -> VibeUIO {
        .dummy0
    }
    
    func deleteVibe(eventID: String, vibeID: Int) async throws {
        
    }
    
    func modifyVibe(vibeID: Int, rating: Double, comment: String?, previousImageURLs: [String], images: [Image]?) async throws -> VibeUIO {
        var vibe = VibeUIO(
            id: vibeID,
            user: SimpleUserUIO(id: 1, nickname: "가나다", profileImageURL: nil),
            event: SimpleEventUIO(id: "dummyID", name: "Dummy Title", posterURL: nil, dDay: 7, startDate: "2024.12.05", endDate: "2024.12.05", placeName: "공연장"),
            rating: rating,
            imageURLs: VibeUIO.dummy0.imageURLs,
            comment: comment,
            createdDate: VibeUIO.dummy0.createdDate,
            likeCount: VibeUIO.dummy0.likeCount,
            replyCount: VibeUIO.dummy0.replyCount
        )
        
        return vibe
    }
    
    func checkIfUserUploadedVibe(userID: Int) async throws -> Int {
        1
    }
    
    func getVibeWithVibeID(vibeID: Int) async throws -> VibeUIO {
        let vibes = VibeUIO.dummies.filter { $0.id == vibeID }
        
        if let vibe = vibes.first {
            return vibe
        } else {
            throw VibeError.notFound
        }
    }
}

private extension MockVibeService {
    enum VibeError: Error {
        case notFound
    }
}
