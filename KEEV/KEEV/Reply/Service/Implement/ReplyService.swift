//
//  ReplyService.swift
//  KEEV
//
//  Created by Doran on 11/27/24.
//

import Combine
import Foundation

class ReplyService: ReplyServiceProtocol, KEEVErrorHandler {
    typealias Layer = ReplyService
    
    static let layer: LayerType = .service(of: "ReplyService")
    
    private let networkUtility = NetworkUtility()
    private let tokenUtility = TokenUtility.shared
    private var currentUser: DetailUserUIO?
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    
    private var cancellables = Set<AnyCancellable>()
    
    /// 초기화 시 JSONDecoder를 주입받도록 변경
    init(currentUser: DetailUserUIO? = nil) {
        self.currentUser = currentUser
        NotificationCenter.Publisher.userInfoPublisher
            .sink { [weak self] user in
                guard let self else { return }
                self.currentUser = user
            }
            .store(in: &cancellables)
    }
    
    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
        cancellables.removeAll()
    }
    
    /// 바이브에 대한 댓글을 가져오는 함수
    ///
    /// - Parameters:
    ///   - vibeID : 바이브 아이디
    ///   - userID: 작성한 사용자 아이디
    ///
    /// 키체인에서 accessToken을 가져옵니다.
    /// ReplyHTTPRequestRouter를 통해 라우터를 만듭니다.
    /// 만든 라우터로 서버에 vibeID를 request 하고 바이브에 대한 댓글을 가져옵니다.
    ///
    /// - Returns: 바이브에 대한 댓글들
    ///
    /// - Author: Doran
    func fetchReplies(for vibeID: Int) async throws -> [ReplyUIO] {
        try await doAsyncWithException(caller: "fetchReplies") {
            let accessToken = try await getAccessToken()
            let router = ReplyHTTPRequestRouter.fetchReplies(token: accessToken, vibeID: vibeID)
            
            let data = try await networkUtility.request(router: router)
            
            let replyDTOs = try jsonDecoder.decode([ReplyDTO].self, from: data)
            let currentUserID = currentUser?.id
            let replies = replyDTOs.map { ReplyUIO(reply: $0, currentUserID: currentUserID) }
            
            return replies
        }
    }
    
    /// 바이브에 댓글을 추가하는 함수
    ///
    /// - Parameters:
    ///   - vibeID: 바이브 아이디
    ///   - text: 추가하고자 하는 텍스트
    ///   - userID: 작성한 사용자 아이디
    ///
    /// 키체인에서 accessToken을 가져옵니다.
    /// ReplyHTTPRequestRouter를 통해 라우터를 만듭니다.
    /// 만든 라우터로 서버에 vibeID와 추가하고자하는 Text를 request하고 바이브에 댓글을 작성합니다.
    ///
    /// - Returns: 추가한 댓글
    ///
    /// - Author: Doran
    func addReply(to vibeID: Int, text: String) async throws -> ReplyUIO {
        try await doAsyncWithException(caller: "addReply") {
            let accessToken = try await getAccessToken()
            let router = ReplyHTTPRequestRouter.addReply(token: accessToken, vibeID: vibeID, text: text)
            
            let data = try await networkUtility.request(router: router)
            
            let replyDTO = try jsonDecoder.decode(ReplyDTO.self, from: data)
            let currentUserID = currentUser?.id
            let reply = ReplyUIO(reply: replyDTO, currentUserID: currentUserID)
            
            return reply
        }
    }
    
    /// 바이브에 대한 댓글을 수정하는 함수
    ///
    /// - Parameters:
    ///   - reply: 수정할 하는 댓글 객체
    ///   - updatedReply: 반영되는 댓글 텍스트
    ///   - userID: 작성한 사용자 아이디
    ///
    /// 키체인에서 accessToken을 가져옵니다.
    /// ReplyHTTPRequestRouter를 통해 라우터를 만듭니다.
    /// 만든 라우터로 서버에 replyID와 vibeID, 수정하고자 하는 텍스트를 request하고 바이브의 댓글을 수정합니다.
    ///
    /// - Throws: 수정할 댓글을 찾지 못할 경우 에러
    /// - Returns: 수정 완료한 객체
    ///
    /// - Author: Doran
    func modifyReply(_ reply: ReplyUIO, updatedText: String) async throws -> ReplyUIO {
        try await doAsyncWithException(caller: "modifyReply") {
            let accessToken = try await getAccessToken()
            let router = ReplyHTTPRequestRouter.modifyReply(
                token: accessToken,
                replyID: "\(reply.id)",
                vibeID: "\(reply.vibeID)",
                updatedText: updatedText
            )
            
            let data = try await networkUtility.request(router: router)
            
            let replyDTO = try jsonDecoder.decode(ReplyDTO.self, from: data)
            let currentUserID = currentUser?.id
            let reply = ReplyUIO(reply: replyDTO, currentUserID: currentUserID)
            
            return reply
        }
    }
    
    /// 바이브에 대한 댓글을 삭제하는 함수
    ///
    /// - Parameters:
    ///   - replyID: 삭제할 댓글 아이디
    ///
    /// - Throws: 삭제할 댓글을 찾지 못할 경우 에러
    ///
    /// - Author: Doran
    func deleteReply(_ replyID: Int) async throws {
        try await doAsyncWithException(caller: "deleteReply") {
            let accessToken = try await getAccessToken()
            let router = ReplyHTTPRequestRouter.deleteReply(token: accessToken, replyID: "\(replyID)")
            
            _ = try await networkUtility.requestWithStatusCode(router: router)
        }
    }
}

extension ReplyService {
    private func getAccessToken() async throws -> String {
        try await tokenUtility.fetchToken(for: .access)
    }
}
