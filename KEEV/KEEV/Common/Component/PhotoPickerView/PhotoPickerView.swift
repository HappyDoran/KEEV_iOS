//
//  CustomAlertViewModifier.swift
//  KEEV
//
//  Created by Doran on 10/25/24.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @State private var selectedItems =  [PhotosPickerItem]()
    @State private var selectedImages = [Image]()
    @Binding private var isPresentedError: Bool
    private let maxSelectedCount: Int = 5
    
    private var disabled: Bool {
        selectedImages.count >= maxSelectedCount
    }
    
    private var availableSelectedCount: Int {
        maxSelectedCount - selectedImages.count
    }
    
    init(isPresentedError: Binding<Bool>){
        self._isPresentedError = isPresentedError
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                PhotosPicker(
                    selection: $selectedItems,
                    maxSelectionCount: maxSelectedCount,
                    matching: .images,
                    photoLibrary: PHPhotoLibrary.shared()
                ) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 112, height: 112)
                            .foregroundColor(.gray800)
                        VStack(spacing: 8){
                            Image(systemName: "camera.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 45, height: 29)
                                .foregroundColor(.gray500)
                            
                            HStack(spacing: 0){
                                Text("\(selectedImages.count)").figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                                    .foregroundColor(.gray300)
                                
                                Text(" / 5").figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                                    .foregroundColor(.gray500)
                            }
                        }
                    }
                    .onChange(of: selectedItems) { _, newValue in
                        handleSelectedPhotos()
                    }
                }
                ForEach(0..<selectedImages.count, id: \.self) { i in
                    ZStack {
                        selectedImages[i]
                            .resizable()
                            .scaledToFill()
                            .frame(width: 112, height: 112)
                            .cornerRadius(16)
                        
                    }
                }
                ForEach(0..<availableSelectedCount, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 112, height: 112)
                        .foregroundColor(.gray900)
                }
            }
        }
    }
}

extension PhotoPickerView {
    private func handleSelectedPhotos() {
        Task {
            selectedImages.removeAll()
            for item in selectedItems {
                if let image: Image = try? await item.loadTransferable(type: Image.self) {
                    selectedImages.append(image)
                }
            }
        }
    }
}

struct PhotoPickerView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var selectedImages: [UIImage] = []
        @State private var isPresentedError: Bool = false

        var body: some View {
            PhotoPickerView( isPresentedError: $isPresentedError)
        }
    }

    static var previews: some View {
        PreviewWrapper()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
