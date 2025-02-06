//
//  ProfileVibeView.swift
//  KEEV
//
//  Created by Yune Cho on 11/16/24.
//

import SwiftUI

/// 프로필 화면 하단에 표시되는 바이브 영역
///
/// 프로필 화면 하단에 표시되는 바이브 영역입니다.
///
/// 사용자 본인의 프로필일 경우에는 '나의 바이브', 타 사용자의 프로필일 경우에는 '바이브'로 타이틀이 표시됩니다.
///
/// - Author: 라움
struct ProfileVibeView: View {
    @Injected private var vibeService: any VibeServiceProtocol
    @Injected private var service: any ActivityServiceProtocol
    
    private let userID: Int?
    private let isMyProfile: Bool
    @Binding private var selectedVibeViewType: VibeViewType
    @Binding private var error: Error?
    
    init(userID: Int?, isMyProfile: Bool, selectedVibeViewType: Binding<VibeViewType>, error: Binding<Error?>) {
        self.userID = userID
        self.isMyProfile = isMyProfile
        self._selectedVibeViewType = selectedVibeViewType
        self._error = error
    }
    
    @State private var vibes: [VibeUIO]? = nil
    
    private var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            profileVibeViewHeader
            if let vibes = vibes {
                switch selectedVibeViewType {
                case .list:
                    LazyVStack(spacing: 20) {
                        ForEach(vibes) { vibe in
                            NavigationLink {
                                LazyView(VibeDetailScreen(vibe: vibe))
                            } label: {
                                ProfileVibeListCell(vibe: vibe)
                            }
                        }
                    }
                case .table:
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(vibes) { vibe in
                            NavigationLink {
                                LazyView(VibeDetailScreen(vibe: vibe))
                            } label: {
                                ProfileVibeTableCell(vibe: vibe)
                            }
                            .aspectRatio(114/152, contentMode: .fill)
                        }
                    }
                }
            } else {
                if userID != nil {
                    ProgressView()
                } else {
                    Text("회원가입을 하고 바이브를 남겨보세요!")
                }
            }
        }
        .onAppear {
            Task {
                do {
                    if let userID {
                        vibes = try await service.getUserVibeList(userID: userID)
                    }
                } catch let failToFetchVibes {
                    error = failToFetchVibes
                }
            }
        }
        .padding(.top, 24)
        .padding(.bottom, 20)
        .padding(.horizontal, 16)
        .sensoryFeedback(.impact, trigger: selectedVibeViewType)
    }
}

private extension ProfileVibeView {
    var profileVibeViewHeader: some View {
        HStack(spacing: 0) {
            vibeViewHeaderTitle
            
            Spacer()
            
            vibeListViewButton
            
            vibeTableViewButton
        }
    }
    
    var vibeViewHeaderTitle: some View {
        HStack(spacing: 0) {
            Text(isMyProfile ? "나의 바이브" : "바이브")
                .figmaFont(PretendardFont.title(style: .sm))
                .foregroundStyle(.gray100)
                .padding(.trailing, 8)
            
            Text("\(vibes?.count ?? 0)")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                .foregroundStyle(.brand500)
                .padding(.trailing, 2)
            
            Text("개")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                .foregroundStyle(.gray500)
        }
    }
    
    var vibeListViewButton: some View {
        Button {
            selectedVibeViewType = .list
        } label: {
            Image(systemName: "rectangle.grid.1x2.fill")
                .figmaFont(PretendardFont.title(style: .xs))
                .frame(width: 32, height: 32)
                .foregroundStyle(selectedVibeViewType == .list ? .gray100 : .gray700)
        }
    }
    
    var vibeTableViewButton: some View {
        Button {
            selectedVibeViewType = .table
        } label: {
            Image(systemName: "rectangle.grid.2x2.fill")
                .figmaFont(PretendardFont.title(style: .xs))
                .frame(width: 32, height: 32)
                .foregroundStyle(selectedVibeViewType == .table ? .gray100 : .gray700)
        }
    }
}

#Preview {
    ProfileVibeView(userID: 1, isMyProfile: true, selectedVibeViewType: .constant(.list), error: .constant(nil))
}
