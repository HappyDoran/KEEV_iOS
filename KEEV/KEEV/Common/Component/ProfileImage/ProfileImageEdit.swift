//
//  ProfileImageEdit.swift
//  KEEV
//
//  Created by Doran on 10/28/24.
//

import SwiftUI
import PhotosUI

/// 프로필 수정시 들어가는 뷰
///
/// 따로 만들어진 프로필 사진 첨부 뷰와 카메라 아이콘 뷰를 합쳐서 만들어 놓은 뷰입니다.
///
/// - Author: Doran
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
