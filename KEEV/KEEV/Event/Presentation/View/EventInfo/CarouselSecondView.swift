//
//  CarouselSecondView.swift
//  KEEV
//
//  Created by Doran on 11/30/24.
//

import SwiftUI

struct CarouselSecondView: View {
    @Injected private var eventService: any EventServiceProtocol
    @State private var events: [SimpleEventUIO] = []
    
    var body: some View {
        LazyVStack(spacing: 0){
            Rectangle().frame(height: 15)
                .foregroundColor(.grayBG800)
                .padding(.bottom, 16)
            ForEach(events.indices, id: \.self) { index in
                NavigationLink {
                    EventDetailScreen(simpleEvent: events[index])
                } label: {
                    EventListCell(event: events[index])
                }
            }
            .padding(.horizontal, 16)
        }
        .onAppear{
            Task {
                events = await loadEventByID()
            }
        }
    }
}

extension CarouselSecondView {
    private func loadEventByID() async -> [SimpleEventUIO] {
        var loadedEvents: [SimpleEventUIO] = []
        
        let idsToFetch = [
            "1671e69f-d329-45c1-8ef4-e859be43b13b",
            "32966634-483a-4d34-8061-68f8714582f3",
            "614c9326-167f-4fdf-ac68-33c0e26a4467",
            "9de1d239-c6a8-4603-b29e-f935e3be5ebd",
            "bcb216c9-3ff2-4b3b-a433-54bff2dac169",
            "bedfb527-8741-4e48-9fe0-5cde952fdfb2",
            "e80ce1df-0e78-4191-8c43-0e5322897961",
            "f718095a-5f0d-4815-8cf7-a3f3a8df5b52",
            "1ef684cb-a45d-48a4-b5a9-aa386775c6c9",
            "9ddff2d2-1766-45d5-99c6-183b664813e9",
            "ac11870d-7a52-4e51-be64-0fe91b352224"
        ]
        
        await withTaskGroup(of: SimpleEventUIO?.self) { group in
            for id in idsToFetch {
                group.addTask {
                    do {
                        let event = try await eventService.loadDetailEvent(id: Int(id)!)
                        return SimpleEventUIO(detailEventUIO: event)
                    } catch {
                        debugPrint(error.localizedDescription)
                        return nil
                    }
                }
            }
            
            for await event in group {
                if let event = event {
                    loadedEvents.append(event)
                }
            }
        }
        
        return loadedEvents
    }
}

#Preview {
    ScrollView {
        CarouselSecondView()
    }
}
