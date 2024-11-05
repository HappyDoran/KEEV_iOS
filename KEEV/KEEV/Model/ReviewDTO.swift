//
//  ReviewDTO.swift
//  KEEV
//
//  Created by Doran on 10/16/24.
//

import Foundation

/// 공연 리뷰를 담을 모델 입니다.
///
/// 하나의 공연에 대한 리뷰 데이터를 받을 구조체입니다.
///
/// - Author: Doran
struct ReviewDTO: Codable, Identifiable {
    /// 리뷰 고유 ID
    var id : String { event.id }
    /// 공연 데이터
    let event: EventDTO
    /// 사용자가 올린 이미지
    let image: [String]
    /// 사용자가 작성한 텍스트
    let text: String
    /// 별 갯수
    let starCount: Int
    /// 리뷰를 만든 날짜
    let createdDate: Date
}
