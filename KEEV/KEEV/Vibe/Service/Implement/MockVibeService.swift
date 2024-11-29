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
/// - Author: 라움
class MockVibeService: VibeServiceProtocol {
    private var vibes: [VibeUIO] = []
    private var vibeCount = 0
    
    func getVibeCount(eventID: String) async throws -> Int {
        vibeCount
    }
    
    func getPaginatedVibes(page: Int, size: Int, sort: [(SortCase, SortPattern)]) async throws -> PaginatedResponse<VibeUIO> {
        var vibeList: [VibeUIO] = []
        let startIndex = page*size
        
        for index in startIndex..<startIndex + size {
            vibeList.append(
                .init(
                    id: index,
                    user: SimpleUserUIO(id: index, nickname: "더미닉네임\(index)", profileImageURL: nil),
                    event: SimpleEventUIO(id: "dummyID: \(index)", name: "Dummy Title: 이벤트\(index)", posterURL: nil, dDay: 7, startDate: "2024.12.05", endDate: "2024.12.05", placeName: "공연장\(index)"),
                    rating: Double(Int.random(in: 1 ... 10)) / 2,
                    imageURLs: VibeUIO.dummy0.imageURLs,
                    comment: "코멘트 내용\(index)",
                    createdDate: "2024.11.25",
                    likeCount: index,
                    replyCount: index,
                    isMine: index % 10 == 1
                )
            )
        }
        
        if vibeList.isEmpty {
            throw VibeError.notFound
        } else {
            return PaginatedResponse(totalPages: 5, currentPage: page, totalElements: 50, contents: vibeList)
        }
    }
    
    func uploadVibe(eventID: String, rating: Double, comment: String?, images: [UIImage]) async throws -> VibeUIO {
        let newVibe = VibeUIO(
            id: vibeCount + 1,
            user: SimpleUserUIO(id: 123, nickname: "가래떡강아지", profileImageURL: nil),
            event: SimpleEventUIO(id: "135", name: "번개반찬", posterURL: nil, dDay: 0, startDate: "2024.11.26", endDate: "2024.11.26", placeName: "기숙사 휴게실"),
            rating: 4.0,
            imageURLs: [nil],
            comment: "배부르다!",
            createdDate: "2024.11.26",
            likeCount: 0,
            replyCount: 0,
            isMine: true
        )
        
        vibes.append(newVibe)
        vibeCount += 1
        
        return newVibe
    }
    
    func deleteVibe(eventID: String, vibeID: Int) async throws {
        
    }
    
    func modifyVibe(vibeID: Int, rating: Double, comment: String?, previousImageURLs: [String], images: [UIImage]) async throws -> VibeUIO {
        let vibe = VibeUIO(
            id: vibeID,
            user: SimpleUserUIO(id: 1, nickname: "가나다", profileImageURL: nil),
            event: SimpleEventUIO(id: "dummyID", name: "Dummy Title", posterURL: nil, dDay: 7, startDate: "2024.12.05", endDate: "2024.12.05", placeName: "공연장"),
            rating: rating,
            imageURLs: VibeUIO.dummy0.imageURLs,
            comment: comment,
            createdDate: VibeUIO.dummy0.createdDate,
            likeCount: VibeUIO.dummy0.likeCount,
            replyCount: VibeUIO.dummy0.replyCount,
            isMine: true
        )
        
        return vibe
    }
    
    func checkIfUserUploadedVibe(eventID: String, userID: Int) async throws -> Int {
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
