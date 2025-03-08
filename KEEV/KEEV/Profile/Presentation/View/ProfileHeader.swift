//
//  ProfileHeader.swift
//  KEEV
//
//  Created by Yune Cho on 1/12/25.
//

import SwiftUI

/// 프로필 화면 상단 헤더
///
/// 프로필 화면 상단에 표시되는 헤더입니다.
///
/// - Author: 라움
struct ProfileHeader: View {
    let isNavigation: Bool
    let isMyProfile: Bool
    @Binding var showActionSheet: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack(spacing: 0) {
            if isNavigation {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.gray100)
                        .frame(width: 32, height: 32)
                }
            }
            
            Spacer()
            
            switch isMyProfile {
            case true:
                NavigationLink {
                    SettingScreen()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xlarge, bodyWeight: .semibold)))
                        .font(.system(size: 20))
                        .foregroundStyle(.gray100)
                        .imageScale(.medium)
                }
                .tint(.gray100)
            case false:
                Button {
                    showActionSheet = true
                } label: {
                    Image(systemName: "ellipsis")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xlarge, bodyWeight: .semibold)))
                        .font(.system(size: 20))
                        .foregroundStyle(.gray100)
                        .frame(width: 32, height: 32)
                }
            }
        }
        .frame(height: 48)
        .padding(.horizontal, 16)
    }
}

#Preview {
    ProfileHeader(isNavigation: true, isMyProfile: false, showActionSheet: .constant(false))
}
