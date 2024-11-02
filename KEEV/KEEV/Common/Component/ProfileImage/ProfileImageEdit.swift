//
//  ProfileImageEdit.swift
//  KEEV
//
//  Created by Doran on 10/28/24.
//

import SwiftUI
import PhotosUI

/// 프로필 수정시 나오는 PhotosPicker
///
/// - `profileImage`: 프로필 이미지
///
/// 프로필 이미지 수정 시 sheet 혹은 fullScreenCover로 나오는 PhotosPicker입니다.
///
/// 사용방법은 아래와 같습니다.
///
/// 최상단 뷰에 actionSheetForKEEV 모디파이어와 sheet 혹은 fullScreenCover 모디파이어를 사용하고 sheet 혹은 fullScreenCover 모디파이어에 본 뷰를 추가해줍니다.
///
/// ```swift
/// VStack { ... }
/// .actionSheetForKEEV(isPresented: $showActionSheet, defaults: .setProfileImage(modifyHandler: {
/// showProfileImageEditSheet = true
/// }, deleteHandler: {
/// profileImage = nil
/// showActionSheet = false
/// }))
/// .fullScreenCover(isPresented: $showProfileImageEditSheet) {
/// ProfileImageEdit(profileImage: $profileImage)
///     .onDisappear {
///         showActionSheet = false
///     }
/// }
/// ```
///
/// - Author: Doran, 라움
struct ProfileImageEdit: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @Binding var profileImage: UIImage?
    
    var body: some View {
        PhotosPicker("프로필 이미지 선택", selection: $selectedItem, photoLibrary: .shared())
            .photosPickerStyle(.inline)
            .onChange(of: selectedItem) {
                handleSelectedPhoto()
            }
    }
}

extension ProfileImageEdit {
    private func handleSelectedPhoto() {
        Task {
            profileImage = nil
            do {
                if let data = try await selectedItem?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        self.profileImage = uiImage
                    }
                }
            } catch {
                print(error.localizedDescription)
                profileImage = nil
            }
        }
    }
}

#Preview {
    ProfileImageEdit(profileImage: .constant(UIImage(named: "sample")))
}
