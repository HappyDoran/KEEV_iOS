//
//  VibePhotoPickerCell.swift
//  KEEV
//
//  Created by Doran on 11/6/24.
//

import SwiftUI
import PhotosUI

struct VibePhotoPickerCell: View {
    @Binding private var selectedItems: [PhotosPickerItem]
    @Binding private var selectedImages: [UIImage]
    private let maxSelectedCount: Int
    
    init(selectedItems: Binding<[PhotosPickerItem]>, selectedImages: Binding<[UIImage]>, maxSelectedCount: Int) {
        self._selectedItems = selectedItems
        self._selectedImages = selectedImages
        self.maxSelectedCount = maxSelectedCount
    }
    
    var body: some View {
        VStack(spacing: 0){
            photoHeader.padding(.horizontal, 16)
            
            PhotoPickerView(selectedItems: $selectedItems, selectedImages: $selectedImages, maxSelectedCount: maxSelectedCount)
                .padding(.top, 12)
                .padding(.leading, 16)
        }
    }
}

extension VibePhotoPickerCell {
    private var photoHeader: some View {
        HStack(spacing: 0){
            Text("사진")
                .figmaFont(PretendardFont.title(style: .xs))
                .foregroundColor(.gray50)
            Spacer()
            Text("\(selectedItems.count) / \(maxSelectedCount)장")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                .foregroundColor(.gray500)
        }
    }
}

#Preview {
    VibePhotoPickerCell(selectedItems: .constant([]), selectedImages: .constant([]), maxSelectedCount: 5)
        .backgroundForKEEV()
}
