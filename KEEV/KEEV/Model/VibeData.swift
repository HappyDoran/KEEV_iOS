//
//  VibeData.swift
//  KEEV
//
//  Created by Yune Cho on 10/18/24.
//

import Foundation

/// 바이브의 내용을 담을 구조체입니다.
///
/// UserDefaults에 저장하고 불러올 바이브의 내용(공연 정보 + 공연 리뷰)을 담은 구조체입니다.
///
/// - Author: 라움
struct VibeData: Codable, Identifiable {
    /// 리뷰 고유 ID
    let id: String
    /// 공연 이름
    let name: String
    /// 공연 시작 날짜
    let startDate: String
    /// 공연 종료 날짜
    let endDate: String
    /// 공연 위치
    let location: String
    /// 공연 포스터
    let poster: String
    /// 사용자가 올린 이미지
    let image: [String]
    /// 사용자가 작성한 텍스트
    let text: String
    /// 별 갯수
    let starCount: Int
    /// 리뷰를 남긴 날짜
    let reviewDate: Date
}
