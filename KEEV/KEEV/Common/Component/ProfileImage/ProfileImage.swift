//
//  ProfileImage.swift
//  KEEV
//
//  Created by Doran on 10/28/24.
//

import SwiftUI
import PhotosUI

struct ProfileImage: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage?
    
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

#Preview {
    ProfileImage()
}
