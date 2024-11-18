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
        GridItem(),
        GridItem(),
        GridItem()
    ]
    
    var body: some View {
        Section {
            switch selectedVibeViewType {
            case .list:
                ForEach(vibes) { vibe in
                    ProfileVibeListCell(vibe: vibe)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 16)
                }
            case .table:
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(vibes) { vibe in
                        NavigationLink {
                            // 바이브 디테일 화면 만들어지면 연결해야됩니다.
                        } label: {
                            ProfileVibeTableCell(vibe: vibe)
                        }
                    }
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 16)
            }
        } header: {
            profileVibeViewHeader
                .padding(.top, 24)
                .padding(.bottom, 12)
        }
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
        .padding(.horizontal, 16)
    }
    
    var vibeViewHeaderTitle: some View {
        HStack(spacing: 0) {
            Text(isMyProfile ? "나의 바이브" : "바이브")
                .figmaFont(PretendardFont.title(style: .sm))
                .foregroundStyle(.gray100)
                .padding(.trailing, 8)
            
            Text("\(vibes.count)")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium)))
                .foregroundStyle(.brand500)
            
            Text("개")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium)))
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
