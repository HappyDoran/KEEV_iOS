//
//  DetailEventUIO.swift
//  KEEV
//
//  Created by 김준성 on 11/14/24.
//

import Foundation

/// 이벤트 관련 DTO를 이벤트 상세 정보 뷰에 나타내기 위해 변환한 타입
///
/// 이 타입의 생성자에 `DetailEventDTO`만 주입할 수 있습니다.
///
/// - Author: newJunsung
struct DetailEventUIO: Identifiable, Hashable {
    /// 이벤트ID
    let id: Int
    
    /// 이벤트 이름
    let name: String
    
    /// 이벤트 포스터 URL
    let posterURL: URL?
    
    /// 공연 시작까지 남은 날짜
    let dDay: Int?
    
    /// 공연 예약 시작일과 시간
    let reservationStartDate: String?
    
    /// 공연 시작일
    let startDate: String
    
    /// 공연 종료일
    let endDate: String
    
    /// 공연 장소
    let places: [PlaceDTO]
    
    /// 공연 설명 텍스트
    let description: String?
    
    /// 공연 설명 이미지
    let descriptionImageURLs: [URL?]
    
    let placesName: String
    
    init(
        id: Int,
        name: String,
        posterURL: URL?,
        dDay: Int?,
        reservationStartDate: String?,
        startDate: String,
        endDate: String,
        places: [PlaceDTO],
        description: String?,
        descriptionImageURLs: [URL?]
    ) {
        self.id = id
        self.name = name
        self.posterURL = posterURL
        self.dDay = dDay
        self.reservationStartDate = reservationStartDate
        self.startDate = startDate
        self.endDate = endDate
        self.places = places
        self.description = description
        self.descriptionImageURLs = descriptionImageURLs
        let tempPlacesName = places.map(\.name).joined(separator: ", ")
        self.placesName = tempPlacesName.isEmpty ? "공연 장소가 없어요" : tempPlacesName
    }
    
    init(
        id: Int,
        name: String,
        posterURLString: String,
        reservationStartDate: Date,
        startDate: Date,
        endDate: Date,
        places: [PlaceDTO],
        description: String?,
        descriptionImageURLStrings: [String]
    ) {
        self.id = id
        self.name = name
        self.posterURL = URL(string: posterURLString)
        self.dDay = startDate.difference(from: .now)
        self.reservationStartDate = reservationStartDate.toString(format: "yyyy. MM. dd hh:mm")
        self.startDate = startDate.toString(format: "yyyy. MM. dd")
        self.endDate = endDate.toString(format: "yyyy. MM. dd")
        self.places = places
        self.description = description
        self.descriptionImageURLs = descriptionImageURLStrings.map(URL.init)
        let tempPlacesName = places.map(\.name).joined(separator: ", ")
        self.placesName = tempPlacesName.isEmpty ? "공연 장소가 없습니다." : tempPlacesName
    }
    
    init(detailEventDTO event: DetailEventDTO) {
        self.id = event.id
        self.name = event.name
        self.posterURL = URL(string: event.posterURLString)
        self.dDay = event.startDate.difference(from: .now)
        self.reservationStartDate = event.reservationStartDate?.toString(format: "yyyy. MM. dd hh:mm")
        self.startDate = event.startDate.toString(format: "yyyy. MM. dd")
        self.endDate = event.endDate.toString(format: "yyyy. MM. dd")
        self.places = event.places
        self.description = event.description
        self.descriptionImageURLs = event.descriptionImagesURLStrings.map(URL.init)
        let tempPlacesName = event.places.map(\.name).joined(separator: ", ")
        self.placesName = tempPlacesName.isEmpty ? "공연 장소가 없습니다." : tempPlacesName
    }
    
    init(simpleEventUIO event: SimpleEventUIO) {
        self.id = event.id
        self.name = event.name
        self.posterURL = event.posterURL
        self.dDay = event.dDay
        self.reservationStartDate = nil
        self.startDate = event.startDate
        self.endDate = event.endDate
        self.places = []
        self.description = nil
        self.descriptionImageURLs = []
        self.placesName = ""
    }
}

extension DetailEventUIO {
    /// 상세 설명 이미지가 있고 상세 설명 텍스트가 없는 경우
    static let dummy0 = DetailEventUIO(detailEventDTO: .dummy0)
    
    /// 상세 설명 텍스트가 있고 경우, 상세 설명 이미지가 없는 경우
    static let dummy1 = DetailEventUIO(detailEventDTO: .dummy1)
    
    /// 상세 설명과 설명 이미지 둘 다 있는 경우
    static let dummy2 = DetailEventUIO(
        id: SimpleEventDTO.dummy0.id,
        name: SimpleEventDTO.dummy0.name,
        posterURLString: SimpleEventDTO.dummy0.posterURLString,
        reservationStartDate: Date.now,
        startDate: SimpleEventDTO.dummy0.startDate,
        endDate: SimpleEventDTO.dummy0.endDate,
        places: [.init(id: 1, name: "dummyPlace2")],
        description: "대한민국에 신이 강림한 날.\n항상 숭배해야만 해...\n가나다라마바사아자차카타파하고노도로모보소오조초코토포호아야어여이우유오요으에예애얘",
        descriptionImageURLStrings: DetailEventDTO.dummy0.descriptionImagesURLStrings
    )
    
    /// 에러 케이스
    static let dummy3 = DetailEventUIO(id: 282827, name: "DetailEventUIDummy3", posterURL: nil, dDay: nil, reservationStartDate: nil, startDate: "Err", endDate: "Err", places: [.init(id: 1, name: "dummyPlace2")], description: nil, descriptionImageURLs: [nil, nil])
}
