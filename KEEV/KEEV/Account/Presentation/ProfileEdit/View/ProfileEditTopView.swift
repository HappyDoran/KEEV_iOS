//
//  ProfileEditTopView.swift
//  KEEV
//
//  Created by Yune Cho on 11/5/24.
//

import SwiftUI

/// 프로필 수정 화면의 상단 바
///
/// 닫기 버튼과 프로필 수정 타이틀이 있는 프로필 수정 화면 상단 바입니다.
///
/// - Author: 라움
struct ProfileEditTopView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var profileModified: Bool
    @Binding var showCloseAlert: Bool
    var isFocused: FocusState<Bool>.Binding
    
    var body: some View {
        HStack {
            Button {
                isFocused.wrappedValue = false
                if profileModified {
                    showCloseAlert = true
                } else {
                    dismiss()
                }
            } label: {
                HStack {
                    Image(systemName: "xmark")
                        .imageScale(.large)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.gray100)
                    
                    Spacer()
                }
                .frame(width: 58, height: 32)
            }
            
            Spacer()
            
            Text("프로필 수정")
                .figmaFont(PretendardFont.title(style: .xs))
                .foregroundStyle(.gray100)
            
            Spacer()
            
            Rectangle()
                .frame(width: 58, height: 32)
                .foregroundStyle(.clear)
        }
    }
}

#Preview {
    @Previewable @FocusState var isFocused: Bool
    
    ProfileEditTopView(profileModified: .constant(false), showCloseAlert: .constant(false), isFocused: $isFocused)
}
