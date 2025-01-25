//
//  VibeService.swift
//  KEEV
//
//  Created by Yune Cho on 10/19/24.
//

import Combine
import Foundation
import SwiftUI

/// 바이브와 관련된 기능들을 수행하는 VibeService
///
/// 바이브와 관련된 기능들을 수행하는 VibeService입니다.
///
/// - Author: 라움
class VibeService: VibeServiceProtocol, KEEVErrorHandler {
    typealias Layer = VibeService
    
    static let layer: LayerType = .service(of: "VibeService")
    
    private let networkUtility: NetworkUtility = NetworkUtility()
    private let tokenUitility = TokenUtility.shared
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    
    private var userProfile: DetailUserUIO? = nil
    private var subscriptions: Set<AnyCancellable> = []
    
    init() {
        NotificationCenter.Publisher.userInfoPublisher
            .sink { [weak self] user in
                self?.userProfile = user
            }
            .store(in: &subscriptions)
    }
    
    func getVibeCount(eventID: String) async throws -> Int {
        try await doAsyncWithException(caller: "getVibeCount") {
            let router = VibeHTTPRequestRouter.getVibeCount(eventID: eventID)
            
            let (code, data) = try await networkUtility.requestWithStatusCode(router: router)
            
            do {
                guard (200..<300).contains(code) else {
                    let errorMessage = try jsonDecoder.decode(ErrorMessageDTO.self, from: data)
                    throw throwKEEVError(
                        caller: "decode",
                        occurPoint: .remote(code: code, message: errorMessage.message)
                    )
                }
                
                let vibesCount = try jsonDecoder.decode(Int.self, from: data)
                return vibesCount
            } catch {
                throw throwKEEVError(
                    caller: "decode",
                    occurPoint: .local(description: "바이브 개수를 불러오는데 실패했어요."),
                    previousError: error
                )
            }
        }
    }
    
    func getPaginatedVibes(page: Int, size: Int, sort: [(SortCase, SortPattern)] = [(SortCase.createdDate, .descending)]) async throws -> PaginatedResponse<VibeUIO> {
        let sortCases: [SortCase] = sort.map { $0.0 }
        let sortPatterns: [SortPattern] = sort.map { $0.1 }
        
        let router = VibeHTTPRequestRouter.getVibes(page: page, size: size, sort: zip(sortCases, sortPatterns).map { $0.0.sortCase(with: $0.1) })
        
        return try await doAsyncWithException(caller: "getPaginatedVibes") {
            let data = try await networkUtility.request(router: router)
            
            do {
                let paginatedResponseDTO = try jsonDecoder.decode(PaginationDTO<VibeDTO>.self, from: data)
                
                let contents = paginatedResponseDTO.contents.map { VibeUIO(vibeDTO: $0, isMine: userProfile == nil ? false : userProfile?.id == $0.user.id) }
                
                let paginatedResponse = PaginatedResponse<VibeUIO>(
                    totalPages: paginatedResponseDTO.totalPages,
                    currentPage: paginatedResponseDTO.currentPage,
                    totalElements: paginatedResponseDTO.totalElements,
                    contents: contents
                )
                
                return paginatedResponse
            } catch {
                guard let errorMessage = try? jsonDecoder.decode(ErrorMessageDTO.self, from: data) else {
                    throw throwKEEVError(caller: "getPaginatedVibes", occurPoint: .local(description: "데이터를 변환하는데 실패했습니다."), previousError: error)
                }
                throw throwKEEVError(caller: "getPaginatedVibes", occurPoint: .custom(message: errorMessage.message))
            }
        }
    }
    
    func getPaginatedVibes(from eventID: String, page: Int, size: Int, sort: [(SortCase, SortPattern)] = [(SortCase.createdDate, .descending)]) async throws -> PaginatedResponse<VibeUIO> {
        let sortCases: [SortCase] = sort.map { $0.0 }
        let sortPatterns: [SortPattern] = sort.map { $0.1 }
        
        let router = VibeHTTPRequestRouter.getVibesFromEventID(id: eventID, page: page, size: size, sort: zip(sortCases, sortPatterns).map { $0.0.sortCase(with: $0.1) })
        
        return try await doAsyncWithException(caller: "getPaginatedVibesWithID") {
            let data = try await networkUtility.request(router: router)
            
            do {
                let paginatedResponseDTO = try jsonDecoder.decode(PaginationDTO<VibeDTO>.self, from: data)
                
                let contents = paginatedResponseDTO.contents.map { VibeUIO(vibeDTO: $0, isMine: userProfile == nil ? false : userProfile?.id == $0.user.id) }
                
                let paginatedResponse = PaginatedResponse<VibeUIO>(
                    totalPages: paginatedResponseDTO.totalPages,
                    currentPage: paginatedResponseDTO.currentPage,
                    totalElements: paginatedResponseDTO.totalElements,
                    contents: contents
                )
                
                return paginatedResponse
            } catch {
                guard let errorMessage = try? jsonDecoder.decode(ErrorMessageDTO.self, from: data) else {
                    throw throwKEEVError(caller: "getPaginatedVibes", occurPoint: .local(description: "데이터를 변환하는데 실패했습니다."), previousError: error)
                }
                throw throwKEEVError(caller: "getPaginatedVibes", occurPoint: .custom(message: errorMessage.message))
            }
        }
    }
    
    func uploadVibe(eventID: String, rating: Double, comment: String?, images: [UIImage]) async throws -> VibeUIO {
        try await doAsyncWithException(caller: "uploadVibe") {
            let accessToken = try await getAccessToken()
            var builder = MultipartFormBuilder()
            
            let inputData = try JSONSerialization.data(withJSONObject: [
                "rating": rating,
                "comment": comment as Any
            ])
            
            builder.append(name: "vibeData", content: .json(data: inputData))
            for index in 0..<images.count {
                if let jpegData = images[index].jpegData(compressionQuality: 0.7) {
                    builder.append(
                        name: "vibeImages",
                        fileName: "\(eventID)_\(UUID().uuidString)_\(index).jpeg",
                        content: .jpeg(data: jpegData)
                    )
                } else {
                    throw VibeError.multipartFormImageError
                }
            }
            guard let (boundary, data) = builder.build() else { throw VibeError.multipartFormBuilderError }
            
            let router = VibeHTTPRequestRouter.uploadVibe(token: accessToken, eventID: eventID, data: data)
            
            let vibeData = try await networkUtility.requestWithMultipartForm(router: router, boundary: boundary)
            do {
                let vibeDTO = try jsonDecoder.decode(VibeDTO.self, from: vibeData)
                let vibeUIO = VibeUIO(vibeDTO: vibeDTO, isMine: true)
                
                return vibeUIO
            } catch {
                guard let errorMessage = try? jsonDecoder.decode(ErrorMessageDTO.self, from: data) else {
                    throw throwKEEVError(caller: "uploadVibe", occurPoint: .local(description: "\(error)"), previousError: error)
                }
                throw throwKEEVError(caller: "uploadVibe", occurPoint: .local(description: errorMessage.message))
            }
        }
    }
    
    func deleteVibe(vibeID: Int) async throws {
        try await doAsyncWithException(caller: "deleteVibe") {
            let accessToken = try await getAccessToken()
            let router = VibeHTTPRequestRouter.deleteVibe(token: accessToken, vibeID: vibeID)
            
            _ = try await networkUtility.request(router: router)
        }
    }
    
    func modifyVibe(vibeID: Int, rating: Double, comment: String?, previousImageURLs: [String], images: [UIImage]) async throws -> VibeUIO {
        try await doAsyncWithException(caller: "modifyVibe") {
            let accessToken = try await getAccessToken()
            var builder = MultipartFormBuilder()
            
            let inputData = try JSONSerialization.data(withJSONObject: [
                "rating": rating,
                "comment": comment as Any,
                "previousImageURLs": previousImageURLs
            ])
            
            builder.append(name: "vibeData", content: .json(data: inputData))
            for index in 0..<images.count {
                if let jpegData = images[index].jpegData(compressionQuality: 0.7) {
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
    }
    
    func checkIfUserUploadedVibe(eventID: String) async throws -> Int {
        try await doAsyncWithException(caller: "checkIfUserUploadedVibe") {
            let accessToken = try await getAccessToken()
            let router = VibeHTTPRequestRouter.checkIfUserUploadedVibe(token: accessToken, eventID: eventID)
            
            let data = try await networkUtility.request(router: router)
            let vibeID = try jsonDecoder.decode(Int.self, from: data)
            
            return vibeID
        }
    }
    
    func getVibeWithVibeID(vibeID: Int) async throws -> VibeUIO {
        try await doAsyncWithException(caller: "getVibeWithVibeID") {
            let router = VibeHTTPRequestRouter.getVibeWithVibeID(vibeID: vibeID)
            
            let data = try await networkUtility.request(router: router)
            
            let vibeDTO = try jsonDecoder.decode(VibeDTO.self, from: data)
            let vibeUIO = VibeUIO(vibeDTO: vibeDTO, isMine: userProfile == nil ? false : userProfile?.id == vibeDTO.user.id)
            
            
            return vibeUIO
        }
    }
    
    func likeVibe(vibeID: Int) async throws -> Bool {
        true
    }
    
    func cancelLikeVibe(vibeID: Int) async throws -> Bool {
        false
    }
}

extension VibeService {
    private func getAccessToken() async throws -> String {
        try await tokenUitility.fetchToken(for: .access)
    }
    
    private struct VibeCountDTO: Decodable {
        let count: Int
    }
}

enum VibeError: Error {
    case multipartFormBuilderError
    case multipartFormImageError
}
