//
//  ProfileImage.swift
//  KEEV
//
//  Created by Doran on 10/28/24.
//

import SwiftUI
import PhotosUI

/// PhotoPicker를 사용하여 프로필 사진을 첨부, 수정을 하는 구조체
///
/// - `selectedItem`:  picker에서 선택하는 Item, Picker에서 check되는 PhotosPickerItem 타입 변수
/// - `selectedImage`: UI에서 실제로 보여지는 이미지 타입 배열
///
/// - Note: picker에서 프로필 화면 클릭시 Picker가 열린다.
/// nil이였던 selectedImage에 UIImage로 변환된 selectedItem이 복사된다.
///
/// - Author: Doran
struct ProfileImage: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @Binding private var selectedImage: UIImage?
    
    init(selectedImage: Binding<UIImage?>) {
        self._selectedImage = selectedImage
    }
    
    var body: some View {
        PhotosPicker(selection: $selectedItem,
                     matching: .images,
                     photoLibrary: .shared()){
            ZStack{
                if selectedImage != nil {
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .frame(width: 140, height: 140)
                        .scaledToFit()
                        .clipShape(Circle())
                }
                else {
                    Circle().frame(width: 140,height: 140).foregroundColor(.gray900)
                    Image("ProfileImage").resizable().scaledToFit().frame(width: 101.12,height: 114.5).padding(.top, 25.9)
                }
            }
            .onChange(of: selectedItem) {
                handleSelectedPhoto()
            }
        }
        
    }
}

extension ProfileImage {
    private func handleSelectedPhoto() {
        Task {
            selectedImage = nil
            do {
                if let data = try await selectedItem?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        self.selectedImage = uiImage
                    }
                }
            } catch {
                print(error.localizedDescription)
                selectedImage = nil
            }
        }
    }
}

