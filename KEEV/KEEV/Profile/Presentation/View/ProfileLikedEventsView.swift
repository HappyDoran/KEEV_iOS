//
//  ProfileLikedEventsView.swift
//  KEEV
//
//  Created by Yune Cho on 2/16/25.
//

import SwiftUI

/// 프로필 화면 중간에 표시되는 관심 공연 영역
///
/// 프로필 화면 중간에 표시되는 관심 공연 영역입니다.
///
/// - Author: 라움
struct ProfileLikedEventsView: View {
    @Injected private var activityService: any ActivityServiceProtocol
    
    @Environment(AppState.self) private var appState
    
    let userID: Int?
    
    @State private var likedEventsCount: Int = 0
    @State private var likedEvents: [SimpleEventUIO] = []
    
    var body: some View {
        VStack(spacing: 12) {
            likedEventsViewHeader
            
            likedEventsScrollSection
        }
        .onAppear {
            loadLikedEvents()
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
    }
}

private extension ProfileLikedEventsView {
    var likedEventsViewHeader: some View {
        HStack(spacing: 0) {
            likedEventsHeaderTitle
            
            Spacer()
            
            likedEventsMoreButton
        }
    }
    
    var likedEventsHeaderTitle: some View {
        HStack(spacing: 0) {
            Text("관심 공연")
                .figmaFont(PretendardFont.title(style: .sm))
                .foregroundStyle(.gray100)
                .padding(.trailing, 8)
            
            Text("\(likedEventsCount)")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                .foregroundStyle(.brand500)
                .padding(.trailing, 2)
            
            Text("개")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                .foregroundStyle(.gray500)
        }
    }
    
    var likedEventsMoreButton: some View {
        NavigationLink(destination: LikedEventsScreen(userID: userID)) {
            Text("더보기")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                .foregroundStyle(.gray500)
        }
    }
    
    var likedEventsScrollSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(0..<min(likedEvents.count, 5), id: \.self) { index in
                    NavigationLink {
                        EventDetailScreen(simpleEvent: likedEvents[index])
                    } label: {
                        EventThumbnailCell(event: likedEvents[index], showDday: false)
                    }
                }
            }
        }
    }
}

private extension ProfileLikedEventsView {
    func loadLikedEvents() {
        guard let userID else { return }
        Task {
            do {
                let response = try await activityService.getUserLikedEvents(userID: userID, page: 0, size: 10, sort: [(SortCase.createdDate, .descending)])
                likedEventsCount = response.totalElements
                likedEvents = response.contents
            } catch {
                appState.presentError(error)
            }
        }
    }
}

#Preview {
    ProfileLikedEventsView(userID: 1)
}
