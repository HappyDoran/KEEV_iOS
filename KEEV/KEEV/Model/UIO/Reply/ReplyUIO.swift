//
//  ReplyUIO.swift
//  KEEV
//
//  Created by 김준성 on 11/14/24.
//

import Foundation

/// 뷰에서 보여질 ReplyUIO
///
/// - ToDo: ReplyDTO가 생기면 생성자 만들기
/// - Author: newJunsung
struct ReplyUIO: Identifiable, Hashable {
    /// 댓글의 id
    let id: Int
    
    /// 유저의 id
    let userID: Int
    
    /// 유저의 닉네임
    let userNickname: String
    
    /// 유저의 프로필 이미지 URL
    let userProfileImageURL: URL?
    
    let vibeID: Int
    
    /// 댓글 내용 텍스트
    let text: String
    
    /// 앱의 사용자 좋아요를 눌렀는지 여부
    let isLiked: Bool
    
    /// 좋아요 수
    let likeCount: Int
    
    /// 댓글 생성 날짜
    let createdDate: Date
    
    /// 댓글이 오늘로부터 며칠전에 생성됐는지 나타내는 정수
    var createdBefore: Int { Int(Date().timeIntervalSince(createdDate) / TimeUnit.days(of: 1).toSeconds) }
    
    let isMine: Bool
    
    init(
        id: Int,
        user: SimpleUserUIO,
        vibeID: Int,
        text: String,
        isLiked: Bool,
        likeCount: Int,
        createdDate: Date,
        isMine: Bool
    ) {
        self.id = id
        self.userID = user.id
        self.userNickname = user.nickname
        self.userProfileImageURL = user.profileImageURL
        self.vibeID = vibeID
        self.text = text
        self.isLiked = isLiked
        self.likeCount = likeCount
        self.createdDate = createdDate
        self.isMine = isMine
    }
    
    init(reply: ReplyDTO, currentUserID: Int?) {
        id = reply.id
        userID = reply.user.id
        userNickname = reply.user.nickname
        userProfileImageURL = URL(string: reply.user.profileImageURL ?? "")
        vibeID = reply.vibeID
        text = reply.text
        isLiked = reply.isLiked
        likeCount = reply.likeCount
        createdDate = reply.createdDate ?? .now
        isMine = (currentUserID != nil && reply.user.id == currentUserID)
    }
}

extension ReplyUIO {
    /// 오늘 생성됐을 때
    static let dummy0 = ReplyUIO(
        id: 0,
        user: .dummy0,
        vibeID: 1,
        text: "Hello, World!",
        isLiked: true,
        likeCount: 1,
        createdDate: .now,
        isMine: false
    )
    
    /// 1일 전에 생성되고, 좋아요를 누르지 않은 더미 데이터
    static let dummy1 = ReplyUIO(
        id: 1,
        user: .dummy1,
        vibeID: 1,
        text: "Hello, World!",
        isLiked: false,
        likeCount: 1,
        createdDate: .now.addingTimeInterval(-TimeUnit.days(of: 1).toSeconds),
        isMine: true
    )
    
    /// 내용이 엄청 긴 더미 데이터
    static let dummy2 = ReplyUIO(
        id: 2,
        user: .dummy2,
        vibeID: 5,
        text: "사람들의 내 내 봅니다. 까닭이요, 벌레는 나는 듯합니다. 아무 우는 사람들의 잠, 다 별이 이름을 까닭입니다. 소녀들의 새겨지는 않은 하늘에는 버리었습니다. 이름과, 하나의 벌써 토끼, 새겨지는 별이 그리고 것은 없이 있습니다. 했던 위에 아름다운 덮어 밤을 그러나 이름과 까닭이요, 봅니다. 이름자를 어머니, 위에 별 나의 것은 계절이 버리었습니다. 나는 써 하나에 그리고 동경과 가을로 멀듯이, 계십니다. 위에 이네들은 가득 까닭입니다. 못 피어나듯이 아름다운 부끄러운 지나가는 잠, 봅니다. 이름과, 가을 별 아름다운 흙으로 별빛이 봅니다.",
        isLiked: false,
        likeCount: 1,
        createdDate: .now,
        isMine: true
    )
    
    /// 좋아요가 엄청 많은 엄청 오래된 더미데이터
    static let dummy3 = ReplyUIO(
        id: 3,
        user: .dummy2,
        vibeID: 5,
        text: "좋아요가 엄청 많은 엄청 오래된 댓글",
        isLiked: false,
        likeCount: .max,
        createdDate: .init(timeIntervalSince1970: 1),
        isMine: false
    )
}
