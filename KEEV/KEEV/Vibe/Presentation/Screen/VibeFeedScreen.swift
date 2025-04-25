//
//  VibeFeedScreen.swift
//  KEEV
//
//  Created by Doran on 2/8/25.
//

import SwiftUI

private enum EventVibeViewState {
    case loading
    case loaded
    case empty
}

enum FeedSection: CaseIterable {
    case all
    case following
}

struct VibeFeedScreen: LoginCheckableView {
    @Injected private var vibeService: any VibeServiceProtocol
    @Environment(AppState.self) var appState
    
    let userID: Int?
    
    @State private var feedSection: FeedSection = .all
    @State private var vibes: [VibeUIO] = []
    @State private var eventVibesState: EventVibeViewState = .loading
    @State private var currentPage = 0
    @State private var totalPages = 1
    private let pageSize = 7
    @State private var isPresented = false
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VibeFeedHeaderView(feedSection: $feedSection, isPresented: $isPresented)
            
            switch eventVibesState {
            case .loading:
                vibeFeedLoading(feedSection: feedSection)
            case .loaded:
                vibeFeedList(feedSection: feedSection)
            case .empty:
                vibeFeedNotExist
            }
        }
        .backgroundForKEEV()
        .onChange(of: feedSection, {
            eventVibesState = .loading
            currentPage = 0
            totalPages = 1
        })
        .refreshable {
            do {
                let response : PaginatedResponse<VibeUIO>
                switch feedSection {
                case .all:
                    response = try await vibeService.getPaginatedVibes(
                        page: 0,
                        size: pageSize,
                        sort: [(SortCase.createdDate, SortPattern.descending)]
                    )
                case .following:
                    response = try await vibeService.myFollowingsVibes(
                        page: 0,
                        size: pageSize,
                        sort: [(SortCase.createdDate, SortPattern.descending)]
                    )
                }
                
                vibes = response.contents
                totalPages = response.totalPages
                currentPage = 1
                
                if vibes.isEmpty {
                    eventVibesState = .empty
                } else {
                    eventVibesState = .loaded
                }
            } catch {
                appState.presentError(error)
            }
        }
        .fullScreenCover(isPresented: $isPresented) {
            VibeCreateScreen(selectedEvent: nil, isNavigation: false)
        }
    }
}

private extension VibeFeedScreen {
    func vibeFeedList(feedSection: FeedSection) -> some View {
        LazyVStack(spacing: 20) {
            ForEach(vibes.indices, id: \.self) { index in
                NavigationLink {
                    LazyView(VibeDetailScreen(vibe: $vibes[index], vibeDetailpath: .feed) { vibe in
                        self.vibes[index] = vibe
                    } onDelete: { _ in
                        if(vibes.count == 1) {
                            eventVibesState = .empty
                        }
                        self.vibes.remove(at: index)
                    })
                } label: {
                    VibeFeedCell(userID: userID, vibeData: vibes[index])
                }
                .padding(.horizontal, 16)
                .onAppear {
                    if index == vibes.count - 1 && currentPage < totalPages {
                        Task {
                            do {
                                let response: PaginatedResponse<VibeUIO>
                                switch feedSection {
                                case .all:
                                    response = try await vibeService.getPaginatedVibes(
                                        page: currentPage,
                                        size: pageSize,
                                        sort: [(SortCase.createdDate, SortPattern.descending)]
                                    )
                                case .following:
                                    response = try await vibeService.myFollowingsVibes(
                                        page: currentPage,
                                        size: pageSize,
                                        sort: [(SortCase.createdDate, SortPattern.descending)]
                                    )
                                }
                                
                                await MainActor.run {
                                    vibes.append(contentsOf: response.contents)
                                    currentPage += 1
                                }
                            } catch {
                                debugPrint(error)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func vibeFeedLoading(feedSection: FeedSection) -> some View {
        ProgressView()
            .onAppear {
                Task {
                    do {
                        let response : PaginatedResponse<VibeUIO>
                        switch feedSection {
                        case .all:
                            response = try await vibeService.getPaginatedVibes(
                                page: currentPage,
                                size: pageSize,
                                sort: [(SortCase.createdDate, SortPattern.descending)]
                            )
                        case .following:
                            response = try await vibeService.myFollowingsVibes(
                                page: currentPage,
                                size: pageSize,
                                sort: [(SortCase.createdDate, SortPattern.descending)]
                            )
                        }
                        
                        vibes = response.contents
                        totalPages = response.totalPages
                        currentPage += 1
                        
                        if vibes.isEmpty {
                            eventVibesState = .empty
                        } else {
                            eventVibesState = .loaded
                        }
                    } catch {
                        appState.presentError(error)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var vibeFeedNotExist: some View {
        VStack(spacing: 4){
            Text("작성 된 바이브가 없습니다")
                .figmaFont(PretendardFont.title(style: .sm))
                .foregroundColor(.gray500)
            
            Text("가장 먼저 바이브를 작성해 보세요")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                .foregroundColor(.gray500)
        }
        .padding(.bottom, 61)
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    NavigationStack {
        VibeFeedScreen(userID: nil)
    }
}
