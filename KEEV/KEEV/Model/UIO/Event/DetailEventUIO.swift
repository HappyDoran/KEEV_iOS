//
//  DetailEventUIO.swift
//  KEEV
//
//  Created by 김준성 on 11/14/24.
//

import Foundation

struct DetailEventUIO: Identifiable {
    let id: String
    let name: String
    let posterURL: URL?
    let dDay: Int?
    let startDate: String
    let endDate: String
    let placeName: String
    let description: String?
    let descriptionImageURLs: [URL?]
    
    init(
        id: String,
        name: String,
        posterURL: URL?,
        dDay: Int?,
        startDate: String,
        endDate: String,
        placeName: String,
        description: String?,
        descriptionImageURLs: [URL?]
    ) {
        self.id = id
        self.name = name
        self.posterURL = posterURL
        self.dDay = dDay
        self.startDate = startDate
        self.endDate = endDate
        self.placeName = placeName
        self.description = description
        self.descriptionImageURLs = descriptionImageURLs
    }
    
    init(
        id: String,
        name: String,
        posterURLString: String,
        startDate: Date,
        endDate: Date,
        placeName: String,
        description: String?,
        descriptionImageURLStrings: [String]
    ) {
        self.id = id
        self.name = name
        self.posterURL = URL(string: posterURLString)
        self.dDay = startDate.difference(from: .now)
        self.startDate = startDate.toString(format: "yyyy. MM. dd")
        self.endDate = endDate.toString(format: "yyyy. MM. dd")
        self.placeName = placeName
        self.description = description
        self.descriptionImageURLs = descriptionImageURLStrings.map(URL.init)
    }
    
    init(detailEventDTO event: DetailEventDTO) {
        self.id = event.id
        self.name = event.name
        self.posterURL = URL(string: event.posterURLString)
        self.dDay = event.startDate.difference(from: .now)
        self.startDate = event.startDate.toString(format: "yyyy. MM. dd")
        self.endDate = event.endDate.toString(format: "yyyy. MM. dd")
        self.placeName = event.place.name
        self.description = event.description
        self.descriptionImageURLs = event.descriptionImagesURLStrings.map(URL.init)
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
        startDate: SimpleEventDTO.dummy0.startDate,
        endDate: SimpleEventDTO.dummy0.endDate,
        placeName: SimpleEventDTO.dummy0.placeName,
        description: "대한민국에 신이 강림한 날.\n항상 숭배해야만 해...\n가나다라마바사아자차카타파하고노도로모보소오조초코토포호아야어여이우유오요으에예애얘",
        descriptionImageURLStrings: DetailEventDTO.dummy0.descriptionImagesURLStrings
    )
    
    /// 에러 케이스
    static let dummy3 = DetailEventUIO(id: "DetailEventUIODummy3", name: "DetailEventUIDummy3", posterURL: nil, dDay: nil, startDate: "Err", endDate: "Err", placeName: "Err", description: nil, descriptionImageURLs: [nil, nil])
}
