//
//  SimpleUserUIO.swift
//  KEEV
//
//  Created by 김준성 on 11/14/24.
//

import Foundation

/// 사용자에 대한 정보를 보여주는 데이터 타입
///
/// 유저에 대한 정보를 담고 있습니다.
/// id, 닉네임, 프로필 이미지 URL가 있습니다.
///
/// - ToDo: SimpleUserDTO가 생기면 생성자 만들기
/// - Author: newJunsung
struct SimpleUserUIO: Identifiable, Hashable {
    let id: Int
    let nickname: String
    let profileImageURL: URL?
    
    init(id: Int, nickname: String, profileImageURL: URL?) {
        self.id = id
        self.nickname = nickname
        self.profileImageURL = profileImageURL
    }
    
    init(_ user: SimpleUserDTO) {
        self.id = user.id
        self.nickname = user.nickname ?? "guest"
        self.profileImageURL = user.profileImageURL == nil ? nil : URL(string: user.profileImageURL!)
    }
}

extension SimpleUserUIO {
    /// 프로필 사진이 없는 더미 사용자
    static let dummy0 = SimpleUserUIO(id: 1, nickname: "dummy0", profileImageURL: nil)
    
    /// 프로필 사진이 있는 사용자
    static let dummy1 = SimpleUserUIO(id: 2, nickname: "dummy1", profileImageURL: URL(string: "https://image.kmib.co.kr/online_image/2024/1103/2024110311070142113_1730599621_0020687410.jpg"))
    
    /// 이름이 겁나 긴 사용자
    static let dummy2 = SimpleUserUIO(id: 3, nickname: "김수한무 거북이와 두루미 삼천갑자 동방삭 치치카포 사리사리센타 워리워리 세브리깡 무두셀라 구름이 허리케인에 담벼락 담벼락에 서생원 서생원에 고양이 고양이엔 바둑이 바둑이는 돌돌이", profileImageURL: URL(string: "https://image.kmib.co.kr/online_image/2024/1103/2024110311070142113_1730599621_0020687410.jpg"))
}
