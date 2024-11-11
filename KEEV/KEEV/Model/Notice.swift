//
//  Notice.swift
//  KEEV
//
//  Created by Yune Cho on 11/10/24.
//

import Foundation

/// 공지사항을 관리하는 모델
///
/// 공지사항을 관리하는 모델(구조체)입니다.
///
/// 공지사항 ID, 공지사항 제목, 공지 날짜, 공지사항 본문으로 구성되어 있습니다.
///
/// - Author: 라움
struct Notice: Identifiable {
    /// 공지사항 ID
    var id: UUID = UUID()
    /// 공지사항 제목
    var title: String
    /// 공지 날짜
    var date: Date
    /// 공지사항 본문
    var content: String
}
