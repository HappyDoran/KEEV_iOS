//
//  UserFollowUIO.swift
//  KEEV
//
//  Created by Yune Cho on 4/11/25.
//

import Foundation

struct UserFollowUIO: Identifiable {
    let id: Int
    let nickname: String
    let profileImageURL: URL?
    let vibeCount: Int
    let interestedEventCount: Int
    var isFollowing: Bool
    
    init (id: Int, nickname: String, profileImageURL: URL?, vibeCount: Int, interestedEventCount: Int, isFollowing: Bool) {
        self.id = id
        self.nickname = nickname
        self.profileImageURL = profileImageURL
        self.vibeCount = vibeCount
        self.interestedEventCount = interestedEventCount
        self.isFollowing = isFollowing
    }
    
    init(userFollowDTO user: UserFollowDTO) {
        self.id = user.id
        self.nickname = user.nickname
        self.profileImageURL = URL(string :user.profileImageURL ?? "")
        self.vibeCount = user.vibeCount
        self.interestedEventCount = user.interestedEventCount
        self.isFollowing = user.isFollowing
    }
}

extension UserFollowUIO {
    static let dummy0 = UserFollowUIO(id: 1, nickname: "abcd", profileImageURL: nil, vibeCount: 0, interestedEventCount: 0, isFollowing: false)
    
    static let dummy1 = UserFollowUIO(id: 2, nickname: "김수한무 거북이와 두루미 삼천갑자 동방삭 치치카포 사리사리센타 워리워리 세브리깡 무두셀라 구름이 허리케인에 담벼락 담벼락에 서생원 서생원에 고양이 고양이엔 바둑이 바둑이는 돌돌이", profileImageURL: nil, vibeCount: 24, interestedEventCount: 120, isFollowing: true)
    
    static let dummy2 = UserFollowUIO(id: 3, nickname: "dummy0", profileImageURL: nil, vibeCount: 3, interestedEventCount: 7, isFollowing: false)
    
    static let dummy3 = UserFollowUIO(id: 4, nickname: "대상혁", profileImageURL: URL(string: "https://resources.chimhaha.net/article/1720288539228-nu7rc8ymarm.webp"), vibeCount: 13, interestedEventCount: 130, isFollowing: true)
    
    static let dummies = [dummy0, dummy1, dummy2, dummy3]
}
