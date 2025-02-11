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

struct VibeFeedScreen: View {
    @Injected private var vibeService: any VibeServiceProtocol
    
    @Binding var selectedItem: TabbedItem.RawValue
    @State private var vibes: [VibeUIO] = []
    @State private var eventVibesState: EventVibeViewState = .loading
    @State private var currentPage = 0
    @State private var totalPages = 1
    private let pageSize = 7
    @State private var error: Error? = nil
    
    var body: some View {
        ScrollView(showsIndicators: false){
            vibeFeedHeader
            switch eventVibesState {
            case .loading:
                vibeFeedLoading
            case .loaded:
                vibeFeedList
            case .empty:
                vibeFeedNotExist
            }
        }
        .backgroundForKEEV()
        .refreshable {
            do {
                let response : PaginatedResponse<VibeUIO>
                response = try await vibeService.getPaginatedVibes(
                    page: 0,
                    size: pageSize,
                    sort: [(SortCase.createdDate, SortPattern.descending)]
                )
                
                vibes = response.contents
                
                if vibes.isEmpty {
                    eventVibesState = .empty
                } else {
                    eventVibesState = .loaded
                }
                
                totalPages = response.totalPages
                currentPage = 1
                
            } catch let failToRefreshVibe {
                error = failToRefreshVibe
            }
        }
    }
}

private extension VibeFeedScreen {
    var vibeFeedHeader: some View {
        VStack(spacing: 0){
            HStack(spacing: 0){
                Text("피드")
                    .figmaFont(PretendardFont.title(style: .xl))
                Spacer()
            }
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16))
    }
    
    var vibeFeedList: some View {
        LazyVStack(spacing: 20) {
            ForEach(vibes.indices, id: \.self) { index in
                NavigationLink {
                    LazyView(VibeDetailScreen(vibe: $vibes[index]) { vibe in
                        self.vibes[index] = vibe
                    } onDelete: { _ in
                        if(vibes.count == 1) {
                            eventVibesState = .empty
                        }
                        self.vibes.remove(at: index)
                    })
                } label: {
                    VibeFeedCell(vibeData: vibes[index])
                }
                .padding(.horizontal, 16)
                .onAppear {
                    if index == vibes.count - 1 && currentPage < totalPages {
                        Task {
                            do {
                                let response = try await vibeService.getPaginatedVibes(
                                    page: currentPage,
                                    size: pageSize,
                                    sort: [(SortCase.createdDate, SortPattern.descending)]
                                )
                                
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
    
    var vibeFeedLoading: some View {
        ProgressView()
            .onAppear {
                Task {
                    do {
                        let response : PaginatedResponse<VibeUIO>
                        response = try await vibeService.getPaginatedVibes(
                            page: currentPage,
                            size: pageSize,
                            sort: [(SortCase.createdDate, SortPattern.descending)]
                        )
                        
                        vibes.append(contentsOf: response.contents)
                        if vibes.isEmpty {
                            eventVibesState = .empty
                        } else {
                            eventVibesState = .loaded
                        }
                        
                        totalPages = response.totalPages
                        currentPage += 1
                        
                    } catch let failToLoadVibe {
                        error = failToLoadVibe
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct VibeFeedScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VibeFeedScreen(selectedItem: .constant("feed"))
        }
    }
}

