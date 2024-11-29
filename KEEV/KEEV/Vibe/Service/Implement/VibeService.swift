//
//  VibeService.swift
//  KEEV
//
//  Created by Yune Cho on 10/19/24.
//

import Foundation
import SwiftUI

/// 바이브와 관련된 기능들을 수행하는 VibeService
///
/// 바이브와 관련된 기능들을 수행하는 VibeService입니다.
///
/// - Author: 라움
class VibeService: VibeServiceProtocol {
    private let networkUtility: NetworkUtility = NetworkUtility()
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    
    func getPaginatedVibes(page: Int, size: Int, sort: [(SortCase, SortPattern)] = [(SortCase.createdDate, .descending)]) async throws -> PaginatedResponse<VibeUIO> {
        let sortCases: [SortCase] = sort.map { $0.0 }
        let sortPatterns: [SortPattern] = sort.map { $0.1 }
        
        let router = VibeHTTPRequestRouter.getVibes(page: page, size: size, sort: zip(sortCases, sortPatterns).map { $0.0.sortCase(with: $0.1) })
        
        let data = try await networkUtility.request(router: router)
        
        let paginatedResponseDTO = try jsonDecoder.decode(PaginationDTO<VibeDTO>.self, from: data)
        
        let contents = paginatedResponseDTO.contents.map { VibeUIO(vibeDTO: $0, isMine: true) }
        
        let paginatedResponse = PaginatedResponse<VibeUIO>(
            totalPages: paginatedResponseDTO.totalPages,
            currentPage: paginatedResponseDTO.currentPage,
            totalElements: paginatedResponseDTO.totalElements,
            contents: contents
        )
        
        return paginatedResponse
    }
    
    func uploadVibe(eventID: String, rating: Double, comment: String?, images: [UIImage]) async throws -> VibeUIO {
        let accessToken = try getAccessToken()
        var builder = MultipartFormBuilder()
        
        let inputData = try JSONSerialization.data(withJSONObject: [
            "rating": rating,
            "comment": comment as Any
        ])
        
        builder.append(name: "vibeData", content: .json(data: inputData))
        for index in 0..<images.count {
            if let jpegData = images[index].jpegData(compressionQuality: 0.8) {
                builder.append(
                    name: "vibeImages",
                    fileName: "\(eventID)_user1_\(index).jpeg",
                    content: .jpeg(data: jpegData)
                )
            } else {
                throw VibeError.multipartFormImageError
            }
        }
        guard let (boundary, data) = builder.build() else { throw VibeError.multipartFormBuilderError }
        
        let router = VibeHTTPRequestRouter.uploadVibe(token: accessToken, eventID: eventID, data: data)
        
        let vibeData = try await networkUtility.requestWithMultipartForm(router: router, boundary: boundary)
        let vibeDTO = try jsonDecoder.decode(VibeDTO.self, from: vibeData)
        let vibeUIO = VibeUIO(vibeDTO: vibeDTO, isMine: true)
        
        return vibeUIO
    }
    
    func deleteVibe(eventID: String, vibeID: Int) async throws {
        let accessToken = try getAccessToken()
        let router = VibeHTTPRequestRouter.deleteVibe(token: accessToken, eventID: eventID, vibeID: vibeID)
        
        _ = try await networkUtility.request(router: router)
    }
    
    func modifyVibe(vibeID: Int, rating: Double, comment: String?, previousImageURLs: [String], images: [UIImage]) async throws -> VibeUIO {
        let accessToken = try getAccessToken()
        var builder = MultipartFormBuilder()
        
        let inputData = try JSONSerialization.data(withJSONObject: [
            "rating": rating,
            "comment": comment as Any,
            "previousImageURLs": previousImageURLs
        ])
        
        builder.append(name: "vibeData", content: .json(data: inputData))
        for index in 0..<images.count {
            if let jpegData = images[index].jpegData(compressionQuality: 0.8) {
                builder.append(
                    name: "vibeImages",
                    fileName: "user1_firstVibeImage\(index).jpeg",
                    content: .jpeg(data: jpegData)
                )
            } else {
                throw VibeError.multipartFormImageError
            }
        }
        guard let (boundary, data) = builder.build() else { throw VibeError.multipartFormBuilderError }
        
        let router = VibeHTTPRequestRouter.modifyVibe(token: accessToken, vibeID: vibeID, data: data)
        
        let vibeData = try await networkUtility.requestWithMultipartForm(router: router, boundary: boundary)
        let vibeDTO = try jsonDecoder.decode(VibeDTO.self, from: vibeData)
        let vibeUIO = VibeUIO(vibeDTO: vibeDTO, isMine: true)
        
        return vibeUIO
    }
    
    func checkIfUserUploadedVibe(eventID: String, userID: Int) async throws -> Int {
        let accessToken = try getAccessToken()
        let router = VibeHTTPRequestRouter.checkIfUserUploadedVibe(token: accessToken, eventID: eventID, userID: userID)
        
        let data = try await networkUtility.request(router: router)
        let vibeID = try jsonDecoder.decode(Int.self, from: data)
        
        return vibeID
    }
    
    func getVibeWithVibeID(vibeID: Int) async throws -> VibeUIO {
        let router = VibeHTTPRequestRouter.getVibeWithVibeID(vibeID: vibeID)
        
        let data = try await networkUtility.request(router: router)
        let vibeDTO = try jsonDecoder.decode(VibeDTO.self, from: data)
        let vibeUIO = VibeUIO(vibeDTO: vibeDTO, isMine: true)
        
        return vibeUIO
    }
}

extension VibeService {
    private func getAccessToken() throws -> String {
        guard let accessTokenData = TokenKeyChainUtility().read(tokenTag: "accessToken"),
              let token = String(data: accessTokenData, encoding: .utf8) else {
            print("accessToken not found")
            throw TokenKeyChainError.NotFound
        }
        
        return token
    }
}

enum VibeError: Error {
    case multipartFormBuilderError
    case multipartFormImageError
}
