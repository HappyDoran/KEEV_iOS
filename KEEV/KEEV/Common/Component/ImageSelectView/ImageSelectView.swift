//
//  ImageSelectView.swift
//  KEEV
//
//  Created by Doran on 10/28/24.
//

import SwiftUI
import PhotosUI

/// 프로필 사진이나 배경사진을 선택할 때 나오는 PhotosPicker
///
/// - `image`: 프로필 이미지
///
/// 프로필 사진이나 배경사진 수정 시 sheet 혹은 fullScreenCover로 나오는 PhotosPicker입니다.
///
/// 사용방법은 아래와 같습니다.
///
/// 최상단 뷰에 actionSheetForKEEV 모디파이어와 sheet 혹은 fullScreenCover 모디파이어를 사용하고 sheet 혹은 fullScreenCover 모디파이어에 본 뷰를 추가해줍니다.
///
/// ```swift
/// VStack { ... }
/// .actionSheetForKEEV(isPresented: $showActionSheet, defaults: .setProfileImage(modifyHandler: {
/// showImageSelectSheet = true
/// }, deleteHandler: {
/// profileImage = nil
/// showActionSheet = false
/// }))
/// .fullScreenCover(isPresented: $showImageSelectSheet) {
/// ImageSelectView(image: $profileImage)
///     .onDisappear {
///         showActionSheet = false
///     }
/// }
/// ```
///
/// - Author: Doran, 라움
struct ImageSelectView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @Binding var image: UIImage?
    
    var body: some View {
        PhotosPicker("이미지 선택", selection: $selectedItem, matching: .images, photoLibrary: .shared())
            .photosPickerStyle(.inline)
            .tint(.brand500)
            .onChange(of: selectedItem) {
                handleSelectedPhoto()
            }
    }
}

extension ImageSelectView {
    private func handleSelectedPhoto() {
        image = nil
        Task {
            do {
                if let data = try await selectedItem?.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) {
                    self.image = uiImage
                }
            } catch {
                print(error.localizedDescription)
                image = nil
            }
        }
    }
}

#Preview {
    ImageSelectView(image: .constant(UIImage(named: "sample")))
}
