//
//  CarouselThirdView.swift
//  KEEV
//
//  Created by Doran on 11/30/24.
//

import SwiftUI

struct CarouselThirdView: View {
    @Injected private var eventService: any EventServiceProtocol
    @State private var events: [SimpleEventUIO] = [.dummy0, .dummy1, .dummy2]
    var body: some View {
        VStack(spacing: 0){
            firstArtist()
            secondArtist()
            thirdArtist()
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
    private func firstArtist() -> some View {
        VStack(alignment: .leading, spacing: 0){
            Text("1. Kanye West & Ty Dolla $ign")
                .figmaFont(PretendardFont.title(style: .sm))
                .foregroundColor(.yellow500)
                
            Text("칸예 웨스트 & 타이 달라 사인")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                .foregroundColor(.gray500)
                .padding(.top, 4)
            
            Text("칸예가 14년 만에 한국을 방문해 리스닝 파티로 예정되었던 공연을 깜짝 라이브로 전환하며 큰 화제를 모았습니다. 그는 사상 처음으로 데뷔 앨범부터 최근 앨범까지의 곡들을 메들리로 선보이며 관객들을 사로잡았고, 파트너 타이 달라 사인와 그의 자녀들과 함께한 무대도 좋은 반응을 이끌어냈습니다.".splitWords())
                .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 8)
            
            NavigationLink {
                LazyView(EventDetailScreen(simpleEvent: events[0]))
            } label: {
                EventListCell(event: events[0])
                    .padding(.top, 24)
                    .padding(.bottom, 32)
            }
        }
    }
    
    private func secondArtist() -> some View {
        VStack(alignment: .leading, spacing: 0){
            Text("2. Olivia Rodrigo")
                .figmaFont(PretendardFont.title(style: .sm))
                .foregroundColor(.yellow500)
            
            Text("올리비아 로드리고")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                .foregroundColor(.gray500)
                .padding(.top, 4)
            
            Text("그래미 수상 경력을 가진 2003년생 팝스타 올리비아 로드리고가 한국에서 내한 공연을 펼쳤습니다. 약 1시간 30분 동안 그녀는 다양한 히트곡을 선보이며, 다양한 무대의상과 퍼포먼스로 관객의 뜨거운 반응을 이끌어냈습니다. 특히 달 모양의 조형물을 활용한 퍼포먼스는 공연의 하이라이트로 꼽혔습니다.".splitWords())
                .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 8)
            
            NavigationLink {
                LazyView(EventDetailScreen(simpleEvent: events[1]))
            } label: {
                EventListCell(event: events[1])
                    .padding(.top, 24)
                    .padding(.bottom, 32)
            }
        }
    }
    
    private func thirdArtist() -> some View {
        VStack(alignment: .leading, spacing: 0){
            Text("3. Suede")
                .figmaFont(PretendardFont.title(style: .sm))
                .foregroundColor(.yellow500)
            
            Text("스웨이드")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                .foregroundColor(.gray500)
                .padding(.top, 4)
            
            Text("오아시스, 블러, 펄프와 함께 4대 브릿팝 밴드로 불리는 스웨이드가 8월 23일 내한 공연을 펼쳤었습니다. 매우 더운 날씨와 환경에도 불구하고 열정적인 공연을 펼치고 공연이 끝난 후에도 팬들에게 싸인을 해주는 등 팬서비스를 아끼지 않으며 그들을 기다린 많은 팬들에게 잊을 수 없는 추억을 선사했습니다.".splitWords())
                .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 8)
            
            NavigationLink {
                LazyView(EventDetailScreen(simpleEvent: events[2]))
            } label: {
                EventListCell(event: events[2])
                    .padding(.top, 24)
                    .padding(.bottom, 32)
            }
        }
    }
}

extension CarouselThirdView {
    private func loadEventByID() async -> [SimpleEventUIO]{
        do {
            // IDs 배열
            let idsToFetch = [
                "2e5c0cc0-0424-4351-93d2-fb364b887a23",
                "fe8fea1d-45c4-4098-bd68-56d5775f02bd",
                "efa42141-4d92-4b18-9999-0d927c7068ed"
            ]
            var loadedEvents: [SimpleEventUIO] = []
            
            // 비동기적으로 각 ID에 대해 이벤트를 가져옴
            for id in idsToFetch {
                let event = try await eventService.loadDetailEvent(id: id)
                loadedEvents.append(SimpleEventUIO(detailEventUIO: event))
            }
            
            return loadedEvents
        } catch {
            print(error.localizedDescription)
        }
        
        return [.dummy0, .dummy1, .dummy2]
    }
}


#Preview {
    CarouselThirdView()
}
