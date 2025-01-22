//
//  VibeUIO.swift
//  KEEV
//
//  Created by 김준성 on 11/14/24.
//

import Foundation

/// 뷰에서 보여질 VibeUIO
///
/// - ToDo: VibeDTO가 생기면 생성자 만들기
/// - Author: newJunsung
struct VibeUIO: Identifiable, Hashable {
    /// 바이브의 ID
    let id: Int
    
    /// 유저 ID
    let userID: Int
    
    /// 유저 닉네임
    let userNickname: String
    
    /// 유저 프로필 이미지, URL(string: )을 한 결과 값이기 때문에, nil이 들어갈 수도 있습니다.
    let userProfileImageURL: URL?
    
    /// 바이브에 해당하는 이벤트
    let event: SimpleEventUIO
    
    /// 바이브의 평점
    let rating: Double
    
    /// 바이브의 이미지 URL 목록, URL(string: )을 한 결과 값이기 때문에, nil이 들어갈 수도 있습니다.
    let imageURLs: [URL?]
    
    /// 바이브의 내용
    let comment: String?
    
    /// 바이브 생성 날짜
    let createdDate: String
    
    /// 좋아요 수
    var likeCount: Int
    
    /// 댓글 수
    var replyCount: Int
    
    let isMine: Bool
    
    init(vibeDTO vibe: VibeDTO, isMine: Bool) {
        self.id = vibe.id
        self.userID = vibe.user.id
        self.userNickname = vibe.user.nickname ?? "닉네임 없음"
        if let profileImageURL = vibe.user.profileImageURL {
            self.userProfileImageURL = URL(string: profileImageURL)
        } else {
            self.userProfileImageURL = nil
        }
        self.event = SimpleEventUIO(simpleEventDTO: vibe.event)
        self.rating = vibe.rating
        self.imageURLs = vibe.imageURLs.map { $0.flatMap { URL(string: $0) } }
        self.comment = vibe.comment
        self.createdDate = vibe.createdDate.toString(format: "MM월 dd일")
        self.likeCount = vibe.likeCount
        self.replyCount = vibe.replyCount
        self.isMine = isMine
    }
    
    init(
        id: Int,
        user: SimpleUserUIO, // SimpleUserDTO로 나중에 바꿔야합니다.
        event: SimpleEventUIO,
        rating: Double,
        imageURLs: [URL?],
        comment: String?,
        createdDate: String,
        likeCount: Int,
        replyCount: Int,
        isMine: Bool
    ) {
        self.id = id
        self.userID = user.id
        self.userNickname = user.nickname
        self.userProfileImageURL = user.profileImageURL
        self.event = event
        self.rating = rating
        self.imageURLs = imageURLs
        self.comment = comment
        self.createdDate = createdDate
        self.likeCount = likeCount
        self.replyCount = replyCount
        self.isMine = isMine
    }
}

extension VibeUIO {
    /// 이미지 하나가 누락된 더미 데이터
    static let dummy0 = VibeUIO(
        id: 0,
        user: .dummy0,
        event: .dummy0,
        rating: 3.5,
        imageURLs: [
            URL(string: "https://i.namu.wiki/i/7Uuzidn1EcLXJPolvEHmRR4CDwtQwfgpvXZ0HigeTiW6QCoPWXQ67n5anRe1wRMegTHPRQ5sfBwVdzdJ2MPVWQ.webp"),
            URL(string: "https://image-cdn.hypb.st/https%3A%2F%2Fkr.hypebeast.com%2Ffiles%2F2022%2F07%2F2022-summer-music-festivals-in-korea-water2.jpg?w=1260&cbr=1&q=90&fit=max"),
            nil
                   ],
        comment: "재밌었다",
        createdDate: "10월 18일",
        likeCount: 1,
        replyCount: 17,
        isMine: true
    )
    
    /// 레이팅만 등록한 더미데이터
    static let dummy1 = VibeUIO(
        id: 1,
        user: .dummy1,
        event: .dummy1,
        rating: 3.5,
        imageURLs: [],
        comment: nil,
        createdDate: "10월 18일",
        likeCount: 0,
        replyCount: 0,
        isMine: false
    )
    
    /// 커멘트에 줄바꿈이 많은 더미데이터
    static let dummy2 = VibeUIO(
        id: 2,
        user: .dummy2,
        event: .dummy2,
        rating: 3.5,
        imageURLs: [
            URL(string: "https://xx.bstatic.com/xdata/images/xphoto/1182x887/217150575.jpg?k=193ffc3138dcca4e4790fb91a57da63cbe10aa87b57ab0587ebfc0334265815b&o=?size=M"),
            URL(string: "https://cdn.donggukmedia.com/news/photo/202310/80909_43499_2816.png"),
            URL(string: "https://image-cdn.hypb.st/https%3A%2F%2Fkr.hypebeast.com%2Ffiles%2F2022%2F07%2F2022-summer-music-festivals-in-korea-water2.jpg?w=1260&cbr=1&q=90&fit=max"),
                   ],
        comment: "사람들의 내 내 봅니다. 까닭이요, 벌레는 나는 듯합니다.\n아무 우는 사람들의 잠, 다 별이 이름을 까닭입니다.\n\n소녀들의 새겨지는 않은 하늘에는 버리었습니다.\n\n\n이름과, 하나의 벌써 토끼, 새겨지는 별이 그리고 것은 없이 있습니다.\n했던 위에 아름다운 덮어 밤을 그러나 이름과 까닭이요, 봅니다.\n\n이름자를 어머니, 위에 별 나의 것은 계절이 버리었습니다.\n\n\n나는 써 하나에 그리고 동경과 가을로 멀듯이, 계십니다.\n위에 이네들은 가득 까닭입니다.\n\n못 피어나듯이 아름다운 부끄러운 지나가는 잠, 봅니다.\n\n\n이름과, 가을 별 아름다운 흙으로 별빛이 봅니다.",
        createdDate: "10월 18일",
        likeCount: 4,
        replyCount: 134347,
        isMine: false
    )
    
    /// 커멘트를 안 쓴 더미데이터
    static let dummy3 = VibeUIO(
        id: 3,
        user: .dummy2,
        event: .dummy3,
        rating: 5,
        imageURLs: [
            URL(string: "https://xx.bstatic.com/xdata/images/xphoto/1182x887/217150575.jpg?k=193ffc3138dcca4e4790fb91a57da63cbe10aa87b57ab0587ebfc0334265815b&o=?size=M"),
            URL(string: "https://cdn.donggukmedia.com/news/photo/202310/80909_43499_2816.png"),
            URL(string: "https://image-cdn.hypb.st/https%3A%2F%2Fkr.hypebeast.com%2Ffiles%2F2022%2F07%2F2022-summer-music-festivals-in-korea-water2.jpg?w=1260&cbr=1&q=90&fit=max"),
                   ],
        comment: nil,
        createdDate: "10월 18일",
        likeCount: 122,
        replyCount: 17,
        isMine: true
    )
    
    /// 평점과 커멘트가 있는 후기
    static let dummy4 = VibeUIO(
        id: 4,
        user: .dummy0,
        event: .dummy4,
        rating: 3.5,
        imageURLs: [
            URL(string: "https://xx.bstatic.com/xdata/images/xphoto/1182x887/217150575.jpg?k=193ffc3138dcca4e4790fb91a57da63cbe10aa87b57ab0587ebfc0334265815b&o=?size=M"),
            URL(string: "https://cdn.donggukmedia.com/news/photo/202310/80909_43499_2816.png"),
            URL(string: "https://image-cdn.hypb.st/https%3A%2F%2Fkr.hypebeast.com%2Ffiles%2F2022%2F07%2F2022-summer-music-festivals-in-korea-water2.jpg?w=1260&cbr=1&q=90&fit=max"),
            nil
                   ],
        comment: "재밌었다",
        createdDate: "10월 18일",
        likeCount: 4312,
        replyCount: 17,
        isMine: false
    )
    
    /// 좋아요와 댓글이 엄청 많은 데이터
    static let dummy5 = VibeUIO(
        id: 5,
        user: .dummy0,
        event: .dummy5,
        rating: 3.5,
        imageURLs: [
            URL(string: "https://xx.bstatic.com/xdata/images/xphoto/1182x887/217150575.jpg?k=193ffc3138dcca4e4790fb91a57da63cbe10aa87b57ab0587ebfc0334265815b&o=?size=M"),
            URL(string: "https://cdn.donggukmedia.com/news/photo/202310/80909_43499_2816.png"),
            URL(string: "https://image-cdn.hypb.st/https%3A%2F%2Fkr.hypebeast.com%2Ffiles%2F2022%2F07%2F2022-summer-music-festivals-in-korea-water2.jpg?w=1260&cbr=1&q=90&fit=max"),
                   ],
        comment: "사람들의 내 내 봅니다. 까닭이요, 벌레는 나는 듯합니다. 아무 우는 사람들의 잠, 다 별이 이름을 까닭입니다. 소녀들의 새겨지는 않은 하늘에는 버리었습니다. 이름과, 하나의 벌써 토끼, 새겨지는 별이 그리고 것은 없이 있습니다. 했던 위에 아름다운 덮어 밤을 그러나 이름과 까닭이요, 봅니다. 이름자를 어머니, 위에 별 나의 것은 계절이 버리었습니다. 나는 써 하나에 그리고 동경과 가을로 멀듯이, 계십니다. 위에 이네들은 가득 까닭입니다. 못 피어나듯이 아름다운 부끄러운 지나가는 잠, 봅니다. 이름과, 가을 별 아름다운 흙으로 별빛이 봅니다.",
        createdDate: "10월 18일",
        likeCount: Int.max,
        replyCount: Int.max,
        isMine: false
    )
    
    /// 커멘트가 엄청 긴 더미데이터
    static let dummy6 = VibeUIO(
        id: 6,
        user: .dummy0,
        event: .dummy6,
        rating: 3.5,
        imageURLs: [
            URL(string: "https://xx.bstatic.com/xdata/images/xphoto/1182x887/217150575.jpg?k=193ffc3138dcca4e4790fb91a57da63cbe10aa87b57ab0587ebfc0334265815b&o=?size=M"),
            URL(string: "https://cdn.donggukmedia.com/news/photo/202310/80909_43499_2816.png"),
            URL(string: "https://image-cdn.hypb.st/https%3A%2F%2Fkr.hypebeast.com%2Ffiles%2F2022%2F07%2F2022-summer-music-festivals-in-korea-water2.jpg?w=1260&cbr=1&q=90&fit=max"),
                   ],
        comment: "사람들의 내 내 봅니다. 까닭이요, 벌레는 나는 듯합니다. 아무 우는 사람들의 잠, 다 별이 이름을 까닭입니다. 소녀들의 새겨지는 않은 하늘에는 버리었습니다. 이름과, 하나의 벌써 토끼, 새겨지는 별이 그리고 것은 없이 있습니다. 했던 위에 아름다운 덮어 밤을 그러나 이름과 까닭이요, 봅니다. 이름자를 어머니, 위에 별 나의 것은 계절이 버리었습니다. 나는 써 하나에 그리고 동경과 가을로 멀듯이, 계십니다. 위에 이네들은 가득 까닭입니다. 못 피어나듯이 아름다운 부끄러운 지나가는 잠, 봅니다. 이름과, 가을 별 아름다운 흙으로 별빛이 봅니다.",
        createdDate: "10월 18일",
        likeCount: 4,
        replyCount: 17,
        isMine: true
    )
    
    static let dummy7 = VibeUIO(
        id: 7,
        user: .dummy0,
        event: .dummy6,
        rating: 3.5,
        imageURLs: [nil, nil],
        comment: "fffffff",
        createdDate: "10월 18일",
        likeCount: 4,
        replyCount: 17,
        isMine: false
    )
    
    
    /// 더미데이터 0~5까지 모은 배열
    static let dummies = [dummy0, dummy1, dummy2, dummy3, dummy4, dummy5, dummy6]
}
