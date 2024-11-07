//
//  ProfileEditBackgroundView.swift
//  KEEV
//
//  Created by Yune Cho on 11/5/24.
//

import SwiftUI

/// 프로필 배경사진이 보이는 뷰
///
/// 상단에는 프로필 배경사진이 노출되고 하단에는 앱의 배경색이 표시됩니다.
///
/// 배경사진을 탭할 시 배경사진 수정에 대한 액션시트가 열립니다.
///
/// - Note: 액션시트에 대한 modifier는 ProfileEditScreen에 추가되어있습니다.
/// - Author: 라움
struct ProfileEditBackgroundView: View {
    private let backgroundImage: UIImage?
    @Binding var showBackgroundActionSheet: Bool
    var isFocused: FocusState<Bool>.Binding
    
    init(backgroundImage: UIImage?, showBackgroundActionSheet: Binding<Bool>, isFocused: FocusState<Bool>.Binding) {
        self.backgroundImage = backgroundImage
        self._showBackgroundActionSheet = showBackgroundActionSheet
        self.isFocused = isFocused
    }
    
    var body: some View {
        VStack {
            if let backgroundImage {
                Image(uiImage: backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 202)
                    .clipped()
                    .overlay(content: {
                        Color.black
                            .opacity(0.2)
                    })
                    .onTapGesture {
                        isFocused.wrappedValue = false
                        showBackgroundActionSheet = true
                    }
            } else {
                Color.gray800
                    .frame(height: 202)
                    .overlay(content: {
                        Color.black
                            .opacity(0.2)
                    })
                    .onTapGesture {
                        isFocused.wrappedValue = false
                        showBackgroundActionSheet = true
                    }
            }
            
            Spacer()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    @Previewable @FocusState var isFocused: Bool
    
    ProfileEditBackgroundView(
        backgroundImage: nil,
        showBackgroundActionSheet: .constant(false),
        isFocused: $isFocused
    )
}
