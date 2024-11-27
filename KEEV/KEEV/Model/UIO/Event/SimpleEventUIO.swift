//
//  SimpleEventUI.swift
//  KEEV
//
//  Created by 김준성 on 11/13/24.
//

import Foundation

/// 이벤트 관련 DTO를 이벤트 목록 뷰에 나타내기 위해 간단하게 변환한 타입
///
/// 이 타입의 생성자에 `SimpleEventDTO`와 `DetailEventDTO`를 주입할 수도 있습니다.
///
/// - Author: newJunsung
struct SimpleEventUIO: Identifiable, Hashable {
    /// 이벤트의 id
    let id: String
    
    /// 이벤트 이름
    let name: String
    
    /// 포스터의 URL
    let posterURL: URL?
    
    /// 오늘로부터 공연 시작일까지의 D-day
    let dDay: Int?
    
    /// 이벤트 시작일
    let startDate: String
    
    /// 이벤트 종료일
    let endDate: String
    
    /// 장소 이름
    let placeName: String
    
    init(id: String, name: String, posterURL: URL?, dDay: Int, startDate: String, endDate: String, placeName: String) {
        self.id = id
        self.name = name
        self.posterURL = posterURL
        self.dDay = dDay
        self.startDate = startDate
        self.endDate = endDate
        self.placeName = placeName
    }
    
    init(simpleEventDTO event: SimpleEventDTO) {
        let dateFormat = "yyyy. MM. dd"
        
        self.id = event.id
        self.name = event.name
        self.posterURL = URL(string: event.posterURLString)
        self.dDay = event.startDate.difference(from: .now)
        self.startDate = event.startDate.toString(format: dateFormat)
        self.endDate = event.endDate.toString(format: dateFormat)
        self.placeName = event.placeNames.first ?? "알 수 없음"
    }
    
    init(detailEventDTO event: DetailEventDTO) {
        let dateFormat = "yyyy. MM. dd"
        
        self.id = event.id
        self.name = event.name
        self.posterURL = URL(string: event.posterURLString)
        self.dDay = event.startDate.difference(from: .now)
        self.startDate = event.startDate.toString(format: dateFormat)
        self.endDate = event.endDate.toString(format: dateFormat)
        self.placeName = event.places.map(\.name).first ?? "알 수 없음"
    }
}

extension SimpleEventUIO {
    /// 숭배해야만 하는 데이터1
    static let dummy0 = SimpleEventUIO(simpleEventDTO: .dummy0)
    
    /// 이벤트 이름이 긴 더미데이터
    static let dummy1 = SimpleEventUIO(simpleEventDTO: .dummy1)
    
    /// 뉴준성이 갈 예정인 이벤트1
    static let dummy2 = SimpleEventUIO(simpleEventDTO: .dummy2)
    
    /// 유효하지 않은 포스터 URL을 가진 더미 데이터1
    static let dummy3 = SimpleEventUIO(simpleEventDTO: .dummy3)
    
    /// 유효하지 않은 포스터 URL을 가진 더미 데이터2 
    static let dummy4 = SimpleEventUIO(simpleEventDTO: .dummy4)
    
    /// 이벤트 장소 이름이 긴 더미데이터
    static let dummy5 = SimpleEventUIO(simpleEventDTO: .dummy5)
    
    /// 뉴준성이 갈 예정인 이벤트2
    static let dummy6 = SimpleEventUIO(simpleEventDTO: .dummy6)
    
    /// 숭배해야만 하는 이벤트2
    static let dummy7 = SimpleEventUIO(simpleEventDTO: .dummy7)
    
    /// 라움이 좋아할 만한 이벤트
    static let dummy8 = SimpleEventUIO(simpleEventDTO: .dummy8)
    
    /// 숭배해야만 하는 데이터2
    static let dummy9 = SimpleEventUIO(simpleEventDTO: .dummy9)
    
    /// 더미데이터 0~9까지를 담은 배열
    static let dummies = SimpleEventDTO.dummies.map(SimpleEventUIO.init)
}
