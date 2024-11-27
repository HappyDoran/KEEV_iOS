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
    private let isMyProfile: Bool
    @Binding private var selectedVibeViewType: VibeViewType
    
    init(isMyProfile: Bool, selectedVibeViewType: Binding<VibeViewType>) {
        self.isMyProfile = isMyProfile
        self._selectedVibeViewType = selectedVibeViewType
    }
    
    private let vibes = VibeUIO.dummies
    private var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            profileVibeViewHeader
            
            switch selectedVibeViewType {
            case .list:
                VStack(spacing: 20) {
                    ForEach(vibes) { vibe in
                        ProfileVibeListCell(vibe: vibe)
                    }
                }
            case .table:
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(vibes) { vibe in
                        NavigationLink {
                            VibeDetailScreen(vibe: vibe)
                        } label: {
                            ProfileVibeTableCell(vibe: vibe)
                                .aspectRatio(114/152, contentMode: .fill)
                        }
                    }
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
            
            Text("\(vibes.count)")
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
    ProfileVibeView(isMyProfile: true, selectedVibeViewType: .constant(.table))
}
