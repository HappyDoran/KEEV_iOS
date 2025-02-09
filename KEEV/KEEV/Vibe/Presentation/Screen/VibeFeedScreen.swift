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
    let event : DetailEventUIO
    
    @Injected private var vibeService: any VibeServiceProtocol
    @State private var vibes: [VibeUIO] = []
    @State private var eventVibesState: EventVibeViewState = .loading
    @State private var currentPage = 0
    private let pageSize = 50
    
    init(event: DetailEventUIO){
        self.event = event
    }
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
        .refreshable {
            do {
                vibes = try await vibeService.getPaginatedVibes(from: event.id, page: 0, size: pageSize, sort: [(.createdDate, .descending)]).contents.filter { $0.event.id == event.id }
                
                if vibes.isEmpty {
                    eventVibesState = .empty
                } else {
                    eventVibesState = .loaded
                }
                
                currentPage = 1
            } catch {
                debugPrint(error)
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
                Spacer();
            }
        }
        .padding(.bottom, 16)
    }
    
    var vibeFeedList: some View {
        LazyVStack(spacing: 0) {
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
                    EventVibeCell(vibeData: vibes[index])
                }
                .onAppear {
                    guard let index = vibes.firstIndex(where: { $0.id == vibes[index].id }) else { return }
                    
                    if index % pageSize == (pageSize - 1) {
                        Task {
                            do {
                                let newVibes = try await vibeService.getPaginatedVibes(
                                    from: event.id,
                                    page: currentPage,
                                    size: pageSize,
                                    sort: [(SortCase.createdDate, SortPattern.ascending)]
                                ).contents.filter { $0.event.id == event.id }
                                vibes.append(contentsOf: newVibes)
                                currentPage += 1
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
                        vibes = try await vibeService.getPaginatedVibes(
                            from: event.id,
                            page: currentPage,
                            size: pageSize,
                            sort: [(SortCase.createdDate, SortPattern.descending)]
                        ).contents
                        
                        if vibes.isEmpty {
                            eventVibesState = .empty
                        } else {
                            eventVibesState = .loaded
                        }
                        
                        currentPage += 1
                    } catch {
                        debugPrint(error)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct VibeFeedScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ScrollView(showsIndicators: false){
                VibeFeedScreen(event: .dummy0)
            }
        }
    }
}

