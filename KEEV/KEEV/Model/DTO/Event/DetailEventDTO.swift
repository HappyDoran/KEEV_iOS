//
//  DetailEventDTO.swift
//  KEEV
//
//  Created by 김준성 on 11/12/24.
//

import Foundation


/// 이벤트 상세 정보입니다.
///
/// id, 이름, 이벤트 유형, 장르, 날짜 정보 등으로 구성되어 있습니다.
/// 이 DTO는 이벤트 상세 뷰에서 주로 사용됩니다.
///
/// - Author: newJunsung
struct DetailEventDTO: Decodable, Hashable, Identifiable {
    let id: Int
    
    /// 이벤트의 이름
    let name: String
    
    /// 이벤트의 예약이 시작되는 날짜
    let reservationStartDate: Date?
    
    /// 이벤트가 시작되는 날짜
    let startDate: Date
    
    /// 이벤트가 종료되는 날짜
    let endDate: Date
    
    /// 이벤트가 시작되는 시간(ex. 19시 00분)
    let startTime: Date
    
    /// 포스터 URL 문자열
    let posterURLString: String
    
    /// 이벤트에 대한 상세 설명 텍스트
    let description: String?
    
    /// 이벤트에 대한 상세 설명 이미지
    let descriptionImagesURLStrings: [String]
    
    /// 장소
    let places: [PlaceDTO]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case reservationStartDate
        case startDate
        case endDate
        case startTime
        case posterURLString = "posterURL"
        case description
        case descriptionImagesURLStrings = "descriptionImageURLList"
        case places = "placeList"
    }
    
    init(id: Int, name: String, reservationStartDate: Date?, startDate: Date, endDate: Date, startTime: Date, posterURLString: String, description: String?, descriptionImagesURLStrings: [String], places: [PlaceDTO]) {
        self.id = id
        self.name = name
        self.reservationStartDate = reservationStartDate
        self.startDate = startDate
        self.endDate = endDate
        self.startTime = startTime
        self.posterURLString = posterURLString
        self.description = description
        self.descriptionImagesURLStrings = descriptionImagesURLStrings
        self.places = places
    }
    
    /// 디코딩 데이터에 대해서 날짜를 포매팅 해주고 초기값을 생성
    ///
    /// - Author: Doran
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let tempStartDate = try container.decode(String.self, forKey: .startDate)
        let tempReservationStartDate = try container.decodeIfPresent(String.self, forKey: .reservationStartDate)
        let tempEndDate = try container.decode(String.self, forKey: .endDate)
        let tempStartTime = try container.decode(String.self, forKey: .startTime)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.reservationStartDate = tempReservationStartDate?.toDate(format: "yyyy-MM-dd'T'HH:mm:ss")
        self.startDate = tempStartDate.toDate(format: "yyyy-MM-dd") ?? .now
        self.endDate = tempEndDate.toDate(format: "yyyy-MM-dd") ?? .now
        self.startTime = tempStartTime.toDate(format: "HH:mm:ss") ?? .now
        self.posterURLString = try container.decode(String.self, forKey: .posterURLString)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.descriptionImagesURLStrings = try container.decode([String].self, forKey: .descriptionImagesURLStrings)
        self.places = try container.decode([PlaceDTO].self, forKey: .places)
    }
    
}

extension DetailEventDTO {
    /// 상세 설명 이미지가 있고 상세 설명 텍스트가 없는 경우
    static let dummy0 = DetailEventDTO(
        id: 1321321,
        name: "Best of Fujii Kaze 2020-2024 ASIA TOUR in SEOUL",
        reservationStartDate: .startOfDay(year: 2024, month: 10, day: 21),
        startDate: .startOfDay(year: 2024, month: 12, day: 14),
        endDate: .startOfDay(year: 2024, month: 12, day: 14),
        startTime: Date.startOfDay(year: 2024, month: 12, day: 14).addingTimeInterval(TimeInterval(3600 * 19)),
        posterURLString: "https://image.toast.com/aaaaab/ticketlink/TKL_2/m(19).jpg",
        description: nil,
        descriptionImagesURLStrings: ["http://image.toast.com/aaaaab/ticketlink/TKL_4/kaze_info_0913.jpg"],
        places: [.init(id: 2313, name: "고척 스카이돔")],
    )
    
    /// 상세 설명 텍스트가 있고 경우, 상세 설명 이미지가 없는 경우
    static let dummy1 = DetailEventDTO(
        id: 1329321,
        name: "Best of Fujii Kaze 2020-2024 ASIA TOUR in SEOUL",
        reservationStartDate: .startOfDay(year: 2024, month: 10, day: 21),
        startDate: .startOfDay(year: 2024, month: 11, day: 14),
        endDate: .startOfDay(year: 2024, month: 12, day: 14),
        startTime: Date.startOfDay(year: 2024, month: 12, day: 14).addingTimeInterval(TimeInterval(3600 * 19)),
        posterURLString: "https://image.toast.com/aaaaab/ticketlink/TKL_2/m(19).jpg",
        description: """
취소일자에 따라 아래와 같이 취소수수료가 부과됩니다. 예매일 기준보다 관람일 기준이 우선 적용됩니다.
단, 예매 당일 밤 12시 이전 취소 시에는 취소수수료가 없으며 예매수수료도 환불됩니다. (취소기한 내에 한함)

예매후 7일 이내 : 취소수수료 없음
예매후 8일 ~ 관람일 10일 전 : 뮤지컬/콘서트/클래식 등 공연 장당 4,000원, 연극/전시 등 입장권 장당 2,000원
(단, 최대 티켓금액의 10% 이내)
관람일 9일 전 ~ 7일 전 : 티켓금액의 10%
관람일 6일 전 ~ 3일 전 : 티켓금액의 20%
관람일 2일 전 ~ 1일 전 : 티켓금액의 30%
공연 취소 시 : 없음
""",
        descriptionImagesURLStrings: [],
        places: [.init(id: 2313, name: "고척 스카이돔")],
    )
}
