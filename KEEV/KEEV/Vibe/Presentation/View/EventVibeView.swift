//
//  EventVibeView.swift
//  KEEV
//
//  Created by Doran on 11/18/24.
//

import SwiftUI

/// 바이브 뷰
///
/// - Parameter vibeData: 바이브 객체
///
/// - Author: Doran
struct EventVibeView: View {
    let event: DetailEventUIO
    
    @Injected private var vibeService: any VibeServiceProtocol
    @State private var vibes: [VibeUIO] = []
    @State private var eventVibesState: EventVibeViewState = .loading
    @State private var currentPage = 0
    private let pageSize = 50
    
    init(event: DetailEventUIO) {
        self.event = event
    }
    
    var body: some View {
        EventVibeHeader(event: event, onCreate: {newVibe in
            if(vibes.count == 0) {
                eventVibesState = .loaded
            }
            vibes.insert(newVibe, at: 0)
        })
        
        ScrollView(showsIndicators: false) {
            switch eventVibesState {
            case .loading:
                vibeLoading
            case .loaded:
                vibeList
            case .empty:
                vibeNotExist
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

private enum EventVibeViewState {
    case loading
    case loaded
    case empty
}

private extension EventVibeView {
    /// 이벤트에 대한 바이브 목록이 표시되는 뷰
    ///
    /// - Returns: 이벤트에 대한 바이브 목록
    ///
    /// - Author: Doran, 라움
    var vibeList: some View {
        LazyVStack(spacing: 0) {
            ForEach(vibes.indices, id: \.self) { index in
                NavigationLink {
                    LazyView(VibeDetailScreen(vibe: vibes[index]) { vibe in
                        self.vibes[index] = vibe
                    } onDelete: { _ in
                        if(vibes.count == 1) {
                            eventVibesState = .empty
                        }
                        self.vibes.remove(at: index)
                    })
                } label: {
                    EventVibeCell(vibeData: vibes[index], likeCheckHandler: checkIfUserLikedVibe)
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
    
    /// 바이브가 작성되지 않았을 때 표시되는 뷰
    ///
    /// - Returns: 바이브가 작성되지 않았음을 알리는 뷰
    ///
    /// - Author: 라움
    var vibeNotExist: some View {
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
    
    /// 바이브를 불러올때 표시되는 뷰
    ///
    /// - Returns: 바이브를 불러올때 표시되는 ProgressView
    ///
    /// - Author: Doran, 라움
    var vibeLoading: some View {
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

private extension EventVibeView {
    func checkIfUserLikedVibe(vibeID: Int, isLiked: Binding<Bool>) {
        Task {
            do {
                isLiked.wrappedValue = try await vibeService.checkIfUserLikedVibe(vibeID: vibeID)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ScrollView(showsIndicators: false) {
            EventVibeView(event: .dummy0)
        }
    }
}
