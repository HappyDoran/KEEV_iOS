//
//  CarouselThirdView.swift
//  KEEV
//
//  Created by Doran on 11/30/24.
//

import SwiftUI

private struct EventModel {
    let name: String
    let artist: String
    let description: String
    let eventID: String
}

private let eventElement: [EventModel] = [
    EventModel(name: "1. Vultures Listening Experience", artist: "Kanye West, Ty Dolla $ign", description: "2010년 이후 14년 만에 한국을 방문한 칸예의 내한 공연은 큰 기대를 모았습니다. 당초 라이브 공연이 아닌 리스닝 파티로 예정되었던 이번 공연에서 칸예는 커리어 사상 처음으로 1집부터 10집까지 거의 모든 앨범의 수록곡을 메들리 형식으로 선보이며 관객들을 매료시켰습니다. 파트너 타이 달라 사인과 함께 꾸민 무대도 좋은 반응을 이끌어냈습니다.", eventID:  "2e5c0cc0-0424-4351-93d2-fb364b887a23"),
    EventModel(name: "2. SLOW LIFE SLOW LIVE 2024", artist: "페기 구, joji 등", description: "다양한 국내외 아티스트들이 참여한 이 행사에서는 페기 구, 예지, 오드리 누나, 조지, 럭키 데이, 실리카겔, 하드 라이프, 바밍타이거 등 여러 장르를 넘나드는 인상적인 공연이 펼쳐졌습니다. 페기 구는 대표곡 '나나나'를 선보이며 관객들과 함께 흥을 즐겼고, 조지는 2019년 이후 두 번째 내한 공연을 성공적으로 펼쳤습니다.", eventID: "3ccfa8af-514e-46a7-8ba8-3406a1537509"),
    EventModel(name: "3. 2024 펜타포트 락 페스티벌", artist: "TURNSTILE, SEPULTURA, 잔나비 등", description: "이번 페스티벌에는 총 58개 팀이 참여하여 다양한 장르의 음악을 선보였습니다. 유명 록 밴드 턴스타일(TURNSTILE)을 비롯해 새소년, 마지막 날에는 브라질의 헤비메탈 밴드 세풀투라(SEPULTURA)가 은퇴 투어의 일환으로 방한하여 의미 있는 공연을 펼쳤습니다. 역대 최다 관객인 3일간 15만 명을 기록하며 대한민국의 밴드붐을 실감하게 했습니다.", eventID: "22a16ba9-3847-4101-ad43-d75d8f5ab73d"),
    EventModel(name: "4. 2024 부산 락 페스티벌", artist: "Kasabian, Anne-Marie, 실리카겔 등", description: "2024년 부산국제록페스티벌(BIRF)은 카사비안, 앤 마리, 엘르가든, 국카스텐, 실리카겔, 잔나비, 악뮤 등 국내외 유명 아티스트 78개 팀이 참여하여 관객들에게 다양한 음악적 경험을 선사했습니다.", eventID: "7f6bdb3f-e5ee-467d-aae8-35bcae19c03d"),
    EventModel(name: "5. WONDERLIVET 2024", artist: "ATARASHII GAKKO!, eill, Creepy Nuts 등", description: "원더리벳 2024(WONDERLIVET 2024)'는 J-POP과 아이코닉 아티스트들을 한자리에 모은 국내 최대 규모의 음악 페스티벌로, 약 2만 5천여 명의 관객이 참여하여 성황리에 마무리되었습니다.  특히 일본의 싱어송라이터 eill(에일), 힙합 그룹 Creepy Nuts(크리피 넛츠), 모던 록 밴드 sumika(스미카), 힙합 그룹 ATARASHII GAKKO!(아타라시이 각코!) 등 여러 팀이 내한해 국내의 J-POP 붐을 실감할 수 있었습니다.", eventID: "00086094-0275-4f02-8783-6ccc9ce1203f"),
    EventModel(name: "6. Best of Fujii Kaze 2020-2024 in Seoul", artist: "Fujii Kaze", description: "두 번째 내한이자 일본 가수 최초 고척돔 공연을 한 가수 후지이 카제(a.k.a 교주님), 서울에서 아시아 투어의 피날레를 장식했습니다. 공연 초반부터 “사랑해요”, “뽀뽀해주세요”를 외치며 여심은 물론이고 남심을 녹였는데요, 최상의 컨디션으로 약 2시간의 공연을 소화해내며 관객 모두에게 감동을 선사했습니다. 특히 ‘죽는 게 나아’를 부르고, 다음 곡으로 나온 ‘마츠리’에서 도입부에 ‘도라지 타령’을 삽입하여 한국 팬들을 위한 특별한 무대도 볼 수 있었습니다.", eventID: "1835d673-dea0-458a-92dd-b5c7e72c958b")
]

struct CarouselThirdView: View {
    @Injected private var eventService: any EventServiceProtocol
    @State private var events: [SimpleEventUIO] = []
    var body: some View {
        LazyVStack(spacing: 0){
            ForEach(events.indices, id: \.self) { index in
                eventCell(index: index, event: eventElement[index])
            }
            
        }
        .padding(.horizontal, 16)
        .onAppear{
            Task {
                events = await loadEventByID()
            }
        }
    }
}

extension CarouselThirdView {
    private func eventCell(index: Int, event: EventModel) -> some View {
        VStack(alignment: .leading, spacing: 0){
            Text(event.name)
                .figmaFont(PretendardFont.title(style: .sm))
                .foregroundColor(.blue300)
                
            Text(event.artist)
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                .foregroundColor(.gray500)
                .padding(.top, 4)
            
            Text(event.description.splitWords())
                .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 8)
            
            NavigationLink {
                LazyView(EventDetailScreen(simpleEvent: events[index]))
            } label: {
                EventListCell(event: events[index])
                    .padding(.top, 24)
                    .padding(.bottom, 32)
            }
        }
    }
}

extension CarouselThirdView {
    private func loadEventByID() async -> [SimpleEventUIO] {
        let idsToFetch = [
            "2e5c0cc0-0424-4351-93d2-fb364b887a23",
            "3ccfa8af-514e-46a7-8ba8-3406a1537509",
            "22a16ba9-3847-4101-ad43-d75d8f5ab73d",
            "7f6bdb3f-e5ee-467d-aae8-35bcae19c03d",
            "00086094-0275-4f02-8783-6ccc9ce1203f",
            "1835d673-dea0-458a-92dd-b5c7e72c958b",
        ]
        var loadedEvents: [SimpleEventUIO?] = Array(repeating: nil, count: idsToFetch.count)
        
        await withTaskGroup(of: (Int, SimpleEventUIO?).self) { group in
            for (index, id) in idsToFetch.enumerated() {
                group.addTask {
                    do {
                        let event = try await eventService.loadDetailEvent(id: id)
                        return (index, SimpleEventUIO(detailEventUIO: event))
                    } catch {
                        debugPrint(error.localizedDescription)
                        return (index, nil)
                    }
                }
            }
            
            for await (index, event) in group {
                loadedEvents[index] = event
            }
        }
        
        return loadedEvents.compactMap { $0 }
    }
}


#Preview {
    ScrollView {
        CarouselThirdView()
    }
}
