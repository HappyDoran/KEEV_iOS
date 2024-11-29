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
    private let pageSize = 5
    
    init (eventID: String) {
        self.eventID = eventID
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if !vibes.isEmpty {
                LazyVStack(spacing: 0) {
                    ForEach(vibes.indices, id: \.self) { index in
                        NavigationLink {
                            VibeDetailScreen(vibe: vibes[index]) { vibe in
                                self.vibes[index] = vibe
                            } onDelete: { _ in
                                self.vibes.remove(at: index)
                            }
                        } label: {
                            EventVibeCell(vibeData: vibes[index])
                        }
                        .onAppear {
                            guard let index = vibes.firstIndex(where: { $0.id == vibes[index].id }) else { return }
                            
                            if index % pageSize == (pageSize - 1) {
                                Task {
                                    do {
                                        vibes.append(contentsOf: try await vibeService.getPaginatedVibes(page: currentPage, size: pageSize, sort: [(SortCase.createdDate, SortPattern.ascending)]).contents)
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
                            do {
                                vibes = try await vibeService.getPaginatedVibes(page: currentPage, size: pageSize, sort: [(SortCase.createdDate, SortPattern.ascending)]).contents
                                currentPage += 1
                            } catch {
                                print(error)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#Preview {
    ScrollView(showsIndicators: false) {
        EventVibeView(eventID: "efefweaff")
    }
}
