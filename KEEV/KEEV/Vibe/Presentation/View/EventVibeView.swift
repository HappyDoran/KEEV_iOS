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
    let eventID: String
    
    @Injected private var vibeService: any VibeServiceProtocol
    @State private var vibes: [VibeUIO] = []
    @State private var currentPage = 0
    private let pageSize = 50
    
    init (eventID: String) {
        self.eventID = eventID
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if !vibes.isEmpty {
                LazyVStack(spacing: 0) {
                    ForEach(vibes.indices, id: \.self) { index in
                        NavigationLink {
                            LazyView(VibeDetailScreen(vibe: vibes[index], onUpdate: { updatedVibe in
                                self.vibes[index] = updatedVibe
                            }, onDelete: { _ in
                                self.vibes.remove(at: index)
                            }))
                        } label: {
                            EventVibeCell(vibeData: vibes[index])
                        }
                        .onAppear {
                            guard let index = vibes.firstIndex(where: { $0.id == vibes[index].id }) else { return }
                            print("EventVibeView 스크롤시")
                            if index % pageSize == (pageSize - 1) {
                                Task {
                                    do {
                                        let newVibes = try await vibeService.getPaginatedVibes(
                                            page: currentPage,
                                            size: pageSize,
                                            sort: [(SortCase.createdDate, SortPattern.ascending)]
                                        ).contents.filter { $0.event.id == eventID }
                                        vibes.append(contentsOf: newVibes)
                                        currentPage += 1
                                    } catch {
                                        print(error)
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                ProgressView()
                    .onAppear {
                        Task {
                            print("EventVibeView 제일 초창기")
                            do {
                                let allVibes = try await vibeService.getPaginatedVibes(
                                    page: currentPage,
                                    size: pageSize,
                                    sort: [(SortCase.createdDate, SortPattern.descending)]
                                ).contents
                                vibes = allVibes.filter { $0.event.id == eventID }
                                currentPage += 1
                            } catch {
                                print(error)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .refreshable {
            print("EventVibeView Refreshable")
            do {
                vibes = try await vibeService.getPaginatedVibes(page: 0, size: pageSize, sort: [(.createdDate, .descending)]).contents.filter { $0.event.id == eventID }
                currentPage = 1
            } catch(let replyError) {
                print(replyError)
            }
        }
    }
}

extension EventVibeView {
    private func loadVibes() async {
        do {
            let allVibes = try await vibeService.getPaginatedVibes(
                page: 0,
                size: pageSize,
                sort: [(.createdDate, .descending)]
            ).contents
            vibes = allVibes.filter { $0.event.id == eventID }
            currentPage = 1
        } catch {
            print(error)
        }
    }
}

#Preview {
    ScrollView(showsIndicators: false) {
        EventVibeView(eventID: "d97bcc7a-88aa-4fcd-9411-5785a8ad3e55")
    }
}
