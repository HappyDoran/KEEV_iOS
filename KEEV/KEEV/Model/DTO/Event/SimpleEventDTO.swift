//
//  SimpleEventDTO.swift
//  KEEV
//
//  Created by 김준성 on 11/12/24.
//

import Foundation

/// 서버와 통신할 때 쓰이는 이벤트 DTO 중 하나
///
/// 이벤트에 대한 간략한 정보를 보여줍니다.
/// 이 타입의 경우, 이벤트 정보를 간단하게 보여주는 경우 사용됩니다.
/// 아래와 같은 경우에서 주로 사용됩니다:
/// - 이벤트 목록을 보여줄 때
/// - 바이브에 간략하게 이벤트 정보를 보여줄 때
///
/// - Note: `==`의 기준을 '서로의 `id`가 같은가?'로 했습니다. 또한 hash의 기준 또한 `id`입니다.
/// - Author: newJunsung
struct SimpleEventDTO: Decodable, Identifiable, Hashable {
    /// 이벤트의 ID
    let id: String
    /// 이벤트의 이름
    let name: String
    /// 이벤트가 서버에 등록된 시점
    let createdDate: Date
    /// 이벤트가 시작되는 날짜
    let startDate: Date
    /// 이벤트가 끝나는 날짜
    let endDate: Date
    /// 이벤트 포스터의 URL 문자열
    let posterURLString: String
    /// 이벤트가 열리는 장소
    let placeName: String
}

extension SimpleEventDTO {
    static func == (lhs: SimpleEventDTO, rhs: SimpleEventDTO) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension SimpleEventDTO {
    /// 숭배해야만 하는 데이터1
    static let dummy0 = SimpleEventDTO(
        id: "Christian Billionaire Ye",
        name: "¥$ VULTURES LISTENING EXPERIENCE",
        createdDate: .startOfDay(year: 2024, month: 11, day: 12),
        startDate: .startOfDay(year: 2024, month: 8, day: 23),
        endDate: .startOfDay(year: 2024, month: 8, day: 23),
        posterURLString: "https://pbs.twimg.com/media/GTAcW8NWQAA2bJM.jpg",
        placeName: "고양종합운동장"
    )
    
    /// 이벤트 이름이 긴 더미데이터
    static let dummy1 = SimpleEventDTO(
        id: "dummy1",
        name: "개발하기가 너무나도 귀찮은데 어떻게 해야 아무것도 안하면서 아무것도 한 척하는지를 노래로 표현하는 뉴준성의 콘서트",
        createdDate: .now,
        startDate: .startOfDay(year: 2024, month: 12, day: 25),
        endDate: .startOfDay(year: 2024, month: 12, day: 25),
        posterURLString: "https://ticketimage.interpark.com/Play/image/large/24/24016374_p.gif",
        placeName: "더미 장소 이름 1"
    )
    
    /// 뉴준성이 갈 예정인 이벤트1
    static let dummy2 = SimpleEventDTO(
        id: "dummy2",
        name: "KENSHI YONEZU 2025 WORLD TOUR / JUNK",
        createdDate: .init(timeIntervalSinceNow: -10000),
        startDate: .startOfDay(year: 2025, month: 03, day: 22),
        endDate: .startOfDay(year: 2025, month: 03, day: 23),
        posterURLString: "https://ticketimage.interpark.com/Play/image/large/24/24014669_p.gif",
        placeName: "더미 장소 이름 2"
    )
    
    /// 유효하지 않은 포스터 URL을 가진 더미 데이터1
    static let dummy3 = SimpleEventDTO(
        id: "dummy3",
        name: "더미즈 이벤트 넘버 3",
        createdDate: .init(timeIntervalSinceNow: -10000),
        startDate: .startOfDay(year: 2025, month: 04, day: 22),
        endDate: .startOfDay(year: 2025, month: 05, day: 22),
        posterURLString: "error",
        placeName: "더미 장소 이름 3"
    )
    
    /// 유효하지 않은 포스터 URL을 가진 더미 데이터2
    static let dummy4 = SimpleEventDTO(
        id: "dummy4",
        name: "더미즈 이벤트 넘버 4",
        createdDate: .init(timeIntervalSinceNow: -10000),
        startDate: .startOfDay(year: 2024, month: 11, day: 06),
        endDate: .startOfDay(year: 2024, month: 11, day: 06),
        posterURLString: "error!!!",
        placeName: "더미 장소 이름 4"
    )
    
    /// 이벤트 장소 이름이 긴 더미데이터
    static let dummy5 = SimpleEventDTO(
        id: "dummy5",
        name: "더미즈 이벤트 넘버 5",
        createdDate: .startOfDay(year: 2025, month: 03, day: 22),
        startDate: .startOfDay(year: 2025, month: 03, day: 22),
        endDate: .startOfDay(year: 2025, month: 03, day: 22),
        posterURLString: "https://static.wixstatic.com/media/8ef5ed_0e3b85bb21fa46e4b40449638dd172b1~mv2.jpg/v1/fill/w_1468,h_1566,al_c,q_90,usm_0.66_1.00_0.01,enc_auto/8ef5ed_0e3b85bb21fa46e4b40449638dd172b1~mv2.jpg",
        placeName: "이 더미 장소는 장소일까요? 장소가 아닐까요? 혹시 이 세계는 허울이고 우리는 통속의 뇌가 아닐까요?를 고민하는 포항공과대학교 C5 5층 메인랩"
    )
    
    /// 뉴준성이 갈 예정인 이벤트2
    static let dummy6 = SimpleEventDTO(
        id: "dummy6",
        name: "Best of Fujii Kaze 2020-2024 ASIA TOUR in SEOUL",
        createdDate: .startOfDay(year: 2024, month: 09, day: 25),
        startDate: .startOfDay(year: 2024, month: 12, day: 14),
        endDate: .startOfDay(year: 2024, month: 12, day: 14),
        posterURLString: "https://image.toast.com/aaaaab/ticketlink/TKL_2/m(19).jpg",
        placeName: "더미 장소 이름 6"
    )
    
    /// 숭배해야만 하는 이벤트2
    static let dummy7 = SimpleEventDTO(
        id: "dummy7",
        name: "WORLDS24 T1 우승 기념 이벤트",
        createdDate: .startOfDay(year: 2024, month: 11, day: 06),
        startDate: .startOfDay(year: 2024, month: 11, day: 06),
        endDate: .startOfDay(year: 2024, month: 11, day: 20),
        posterURLString: "https://cmsassets.rgpub.io/sanity/images/dsfx7636/news/479fbae8853c412fb419677462e33e389a80a837-1920x1080.jpg?auto=format&fit=fill&q=80&w=1920",
        placeName: "소환사의 협곡"
    )
    
    static let dummy8 = SimpleEventDTO(
        id: "dummy8",
        name: "챔피언스 리그 바이에른 vs 벤피카",
        createdDate: .startOfDay(year: 2024, month: 11, day: 7),
        startDate: .startOfDay(year: 2024, month: 11, day: 7),
        endDate: .startOfDay(year: 2024, month: 11, day: 7),
        posterURLString: "https://pds.joongang.co.kr/news/component/htmlphoto_mmdata/202307/19/67261eae-92a5-4a3c-bc5e-fff981e33110.jpg",
        placeName: "알리안츠 아레나"
    )
    
    static let dummy9 = SimpleEventDTO(
        id: "dummy9",
        name: "대상혁",
        createdDate: .startOfDay(year: 2024, month: 11, day: 08),
        startDate: .startOfDay(year: 2024, month: 11, day: 08),
        endDate: .startOfDay(year: 2024, month: 11, day: 08),
        posterURLString: "https://resources.chimhaha.net/article/1720288539228-nu7rc8ymarm.webp",
        placeName: "대상혁"
    )
    
    /// 더미데이터 0~9까지를 담은 배열
    static let dummies: [SimpleEventDTO] = [
        .dummy0,
        .dummy1,
        .dummy2,
        .dummy3,
        .dummy4,
        .dummy5,
        .dummy6,
        .dummy7,
        .dummy8,
        .dummy9,
    ]
}
