//
//  UserUIO.swift
//  KEEV
//
//  Created by 김준성 on 11/14/24.
//

import Foundation

/// 사용자에 대한 정보를 보여주는 데이터 타입
///
/// 유저에 대한 정보를 담고 있습니다.
/// id, 닉네임, 프로필 이미지 URL, 배경화면 URL, 한 줄 소개가 있습니다.
///
/// - ToDo: UserDTO가 생기면 생성자 만들기
/// - Author: newJunsung
struct UserUIO: Identifiable {
    /// 사용자의 ID
    let id: Int
    
    /// 사용자의 닉네임
    let nickname: String
    
    /// 사용자의 프로필 사진 URL
    let profileImageURL: URL?
    
    /// 배경화면 URL
    let backgroundImageURL: URL?
    
    /// 한 줄 소개
    let description: String?
    
    init(id: Int, nickname: String, profileImageURL: URL?, backgroundImageURL: URL?, description: String?) {
        self.id = id
        self.nickname = nickname
        self.profileImageURL = profileImageURL
        self.backgroundImageURL = backgroundImageURL
        self.description = description
    }
}

extension UserUIO {
    /// 프사 배경화면 한 줄 소개가 없는 더미 사용자
    static let dummy0 = UserUIO(id: 1, nickname: "dummy0", profileImageURL: nil, backgroundImageURL: nil, description: nil)
    
    /// 닉네임이 긴 더미 사용자
    static let dummy1 = UserUIO(id: 2, nickname: "김수한무 거북이와 두루미 삼천갑자 동방삭 치치카포 사리사리센타 워리워리 세브리깡 무두셀라 구름이 허리케인에 담벼락 담벼락에 서생원 서생원에 고양이 고양이엔 바둑이 바둑이는 돌돌이", profileImageURL: nil, backgroundImageURL: nil, description: nil)
    
    /// 한 줄 설명이 긴 더미 사용자
    static let dummy2 = UserUIO(id: 3, nickname: "dummy0", profileImageURL: nil, backgroundImageURL: nil, description: "김수한무 거북이와 두루미 삼천갑자 동방삭 치치카포 사리사리센타 워리워리 세브리깡 무두셀라 구름이 허리케인에 담벼락 담벼락에 서생원 서생원에 고양이 고양이엔 바둑이 바둑이는 돌돌이")
    
    /// 프로필 사진이 있는 더미 사용자
    static let dummy3 = UserUIO(id: 4, nickname: "대상혁", profileImageURL: URL(string: "https://resources.chimhaha.net/article/1720288539228-nu7rc8ymarm.webp"), backgroundImageURL: nil, description: nil)
    
    /// 프사와 배경화면이 둘 다 있는 더미 사용자
    static let dummy4 = UserUIO(id: 5, nickname: "대상혁", profileImageURL: URL(string: "https://resources.chimhaha.net/article/1720288539228-nu7rc8ymarm.webp"), backgroundImageURL: URL(string: "https://image.kmib.co.kr/online_image/2024/1103/2024110311070142113_1730599621_0020687410.jpg"), description: "화이팅!")
}

