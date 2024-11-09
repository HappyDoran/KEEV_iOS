//
//  VibePhotoPickerCell.swift
//  KEEV
//
//  Created by Doran on 11/6/24.
//

import SwiftUI
import PhotosUI

/// 사진 선택 셀
///
/// - Parameters:
///   - selectedItems: PhotosPicker에서 선택된 아이템
///   - selectedImages: 선택된 이미지
///   - maxSelectedCount: 최대 사진 갯수
///
/// - Author: Doran
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
            // MARK: 헤더, 사진 갯수 표시
            photoHeader.padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
            
            // MARK: 사진 선택 영역
            PhotoPickerView(selectedItems: $selectedItems, selectedImages: $selectedImages, maxSelectedCount: maxSelectedCount)
                .padding(EdgeInsets(top: 12, leading: 16, bottom: 16, trailing: 0))
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
