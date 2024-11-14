//
//  ReplyUIO.swift
//  KEEV
//
//  Created by 김준성 on 11/14/24.
//

import Foundation

struct ReplyUIO: Identifiable {
    let id: Int
    let userID: Int
    let userNickname: String
    let userProfileImageURL: URL?
    let text: String
    let isLiked: Bool
    let likeCount: Int
    let createdDate: Date
    var createdBefore: Int { Int(Date().timeIntervalSince(createdDate) / TimeUnit.days(of: 1).toSeconds) }
    
    init(id: Int, user: SimpleUserUIO, text: String, isLiked: Bool, likeCount: Int, createdDate: Date) {
        self.id = id
        self.userID = user.id
        self.userNickname = user.nickname
        self.userProfileImageURL = user.profileImageURL
        self.text = text
        self.isLiked = isLiked
        self.likeCount = likeCount
        self.createdDate = createdDate
    }
}

extension ReplyUIO {
    /// 오늘 생성됐을 때
    static let dummy0 = ReplyUIO(
        id: 0,
        user: .dummy0,
        text: "Hello, World!",
        isLiked: true,
        likeCount: 1,
        createdDate: .now
    )
    
    /// 1일 전에 생성되고, 좋아요를 누르지 않은 더미 데이터
    static let dummy1 = ReplyUIO(
        id: 1,
        user: .dummy1,
        text: "Hello, World!",
        isLiked: false,
        likeCount: 1,
        createdDate: .now.addingTimeInterval(-TimeUnit.days(of: 1).toSeconds)
    )
    
    /// 내용이 엄청 긴 더미 데이터
    static let dummy2 = ReplyUIO(
        id: 2,
        user: .dummy2,
        text: "사람들의 내 내 봅니다. 까닭이요, 벌레는 나는 듯합니다. 아무 우는 사람들의 잠, 다 별이 이름을 까닭입니다. 소녀들의 새겨지는 않은 하늘에는 버리었습니다. 이름과, 하나의 벌써 토끼, 새겨지는 별이 그리고 것은 없이 있습니다. 했던 위에 아름다운 덮어 밤을 그러나 이름과 까닭이요, 봅니다. 이름자를 어머니, 위에 별 나의 것은 계절이 버리었습니다. 나는 써 하나에 그리고 동경과 가을로 멀듯이, 계십니다. 위에 이네들은 가득 까닭입니다. 못 피어나듯이 아름다운 부끄러운 지나가는 잠, 봅니다. 이름과, 가을 별 아름다운 흙으로 별빛이 봅니다.",
        isLiked: false,
        likeCount: 1,
        createdDate: .now
    )
    
    /// 좋아요가 엄청 많은 엄청 오래된 더미데이터
    static let dummy3 = ReplyUIO(
        id: 2,
        user: .dummy2,
        text: "좋아요가 엄청 많은 엄청 오래된 댓글",
        isLiked: false,
        likeCount: .max,
        createdDate: .init(timeIntervalSince1970: 1)
    )
}
