//
//  LikedEventsScreen.swift
//  KEEV
//
//  Created by Yune Cho on 2/16/25.
//

import SwiftUI

/// 관심 이벤트 목록을 보여주는 스크린
///
/// 관심 이벤트 목록을 보여주는 스크린입니다.
///
/// - Author: 라움
struct LikedEventsScreen: View {
    @Injected private var eventService: any EventServiceProtocol
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentPage = 0
    @State private var totalPages = 1
    private let pageSize = 7
    @State private var events: [SimpleEventUIO] = []
    @State private var error: Error? = nil
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(events.indices, id: \.self) { index in
                    NavigationLink {
                        EventDetailScreen(simpleEvent: events[index])
                    } label: {
                        EventListCell(event: events[index])
                    }
                    .onAppear {
                        if index == events.count - 1 && currentPage < totalPages {
                            Task {
                                await loadLikedEvents(page: currentPage)
                            }
                        }
                    }
                }
            }
            .padding(16)
        }
        .navigationTitle("관심 공연")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 24){
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.gray100)
                    }
                }
            }
        }
        .onAppear {
            if(currentPage == 0){
                Task {
                    await loadLikedEvents(page: currentPage)
                }
            }
        }
        .alertForError($error)
    }
}

private extension LikedEventsScreen {
    func loadLikedEvents(page: Int) async {
        do {
            let response: PaginatedResponse<SimpleEventUIO> = try await eventService.loadLikedEvents(page: page, size: pageSize, sort: [(SortCase.createdDate, .descending)])
            events.append(contentsOf: response.contents)
            totalPages = response.totalPages
            currentPage += 1
        } catch let failToLoadEvent {
            error = failToLoadEvent
        }
    }
}

#Preview {
    LikedEventsScreen()
}
