//
//  ActivityService.swift
//  KEEV
//
//  Created by Yune Cho on 11/28/24.
//

import Combine
import Foundation

/// 사용자가 서비스를 사용하면서 수행한 액티비티를 위한 ActivityService
///
/// 사용자가 서비스를 사용하면서 수행한 액태비티를 위한 ActivityService입니다.
///
/// - Author: 라움
final class ActivityService: ActivityServiceProtocol {
    private let networkUtility = NetworkUtility()
    private let tokenUtility = TokenUtility.shared
    private let jsonDecoder = JSONDecoder()
    
    private var currentUser: DetailUserUIO? = nil
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy.MM.dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateformatter)
        
        NotificationCenter.Publisher.userInfoPublisher
            .sink { [weak self] user in
                self?.currentUser = user
            }
            .store(in: &cancellables)
    }
    
    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
        cancellables.removeAll()
    }
    
    func getUserInfo(userID: Int) async throws -> DetailUserUIO {
        if let currentUser, currentUser.id == userID {
            return currentUser
        }
        
        let router = ActivityHTTPRequestRouter.userInfo(userID: userID)
        
        let data = try await networkUtility.request(router: router)
        
        let response = try jsonDecoder.decode(DetailUserDTO.self, from: data)
        
        let detailUserUIO = DetailUserUIO(detailuserDTO: response)
        
        return detailUserUIO
    }
    
    func getUserVibeList(userID: Int) async throws -> [VibeUIO] {
        let router = ActivityHTTPRequestRouter.userVibeList(userID: userID)
        
        let data = try await networkUtility.request(router: router)
        
        let response = try jsonDecoder.decode(PaginationDTO<VibeDTO>.self, from: data)
        
        if let currentUser {
            return response.contents.map { VibeUIO(vibeDTO: $0, isMine: $0.user.id == currentUser.id ? true : false) }
        } else {
            return response.contents.map { VibeUIO(vibeDTO: $0, isMine: false) }   
        }
    }
}
