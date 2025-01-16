import SwiftUI
import PhotosUI

/// PhotoPicker를 사용하여 사진을 첨부, 삭제, 수정을 하는 구조체
///
/// - `selectedItems`:  picker에서 선택하는 Item, Picker에서 check되는 PhotosPickerItem 타입 배열
/// - `selectedImages`: UI에서 실제로 보여지는 이미지 타입 배열
/// - `previousImages`: 기존에 담겨있었던 이미지 타입 배열. 바이브 생성시에는 빈값, 수정시에는 기존에 있던 이미지.
/// - `maxSelectedCount`: 최대 이미지 수. 5장으로 고정
///
/// - Note: picker에서 Add 버튼 클릭시 SelectedItems가 변하게 되어 onChange modifier가 실행된다.
/// 이때 추가를 해주는 방식이 아닌 selectedItems를 빈 배열로 만들고 선택된 PhotosPickerItems를 형변환 하여 append 한다.
///  Image의 수에 따라서 빈 RoundRectangle이 Image로 바뀌는 형식으로 구현되었다.
/// - Author: Doran
struct PhotoPickerView: View {
    @Binding var selectedItems: [PhotosPickerItem]
    @Binding var selectedImages: [UIImage]
    @Binding var previousImages: [UIImage?]
    @State private var isDelete = false
    let maxSelectedCount: Int
    
    private var availableSelectedCount: Int {
        maxSelectedCount - previousImages.count
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8){
                    PhotosPicker(
                        selection: $selectedItems,
                        maxSelectionCount: availableSelectedCount,
                        matching: .images,
                        photoLibrary: PHPhotoLibrary.shared()
                    ) {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.grayBG700)
                            .overlay {
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.gray500)
                            }
                    }
                    .tint(.brand500)
                    .onChange(of: selectedItems) { _, _ in
                        if !isDelete {
                            handleSelectedPhotos()
                        }
                        isDelete = false
                    }
                    
                    ForEach(0..<previousImages.count, id: \.self) { index in
                        Image(uiImage: previousImages[index] ?? UIImage(systemName: "xmark.circle.fill")!)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white.opacity(0.8))
                                    .frame(width: 20, height: 20)
                                    .onTapGesture {
                                        deletePreviousPhoto(at: index)
                                    }
                                    .padding(8),
                                alignment: .topTrailing
                            )
                    }
                    
                    ForEach(0..<selectedImages.count, id: \.self) { index in
                        Image(uiImage: selectedImages[index])
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white.opacity(0.8))
                                    .frame(width: 20, height: 20)
                                    .onTapGesture {
                                        deleteSelectedPhotos(at: index)
                                    }
                                    .padding(8),
                                alignment: .topTrailing
                            )
                            .id(index + previousImages.count + 1)
                    }
                    .onChange(of: selectedImages) {
                        withAnimation {
                            proxy.scrollTo(previousImages.count + selectedItems.count, anchor: .trailing)
                        }
                    }
                }
            }
        }
    }
}

private extension PhotoPickerView {
    func deletePreviousPhoto(at index: Int) {
        previousImages.remove(at: index)
    }
    
    func deleteSelectedPhotos(at index: Int) {
        selectedImages.remove(at: index)
        isDelete = true
        selectedItems.remove(at: index)
    }
    
    func handleSelectedPhotos() {
        selectedImages.removeAll()
        var tempPhotos = [UIImage]()
        Task {
            for item in selectedItems {
                do {
                    if let data = try await item.loadTransferable(type: Data.self)
                        , let newImage = UIImage(data: data) {
                        tempPhotos.append(newImage)
                    }
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
            selectedImages = tempPhotos
        }
    }
}

struct PhotoPicker_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var selectedItems: [PhotosPickerItem] = []
        @State private var selectedImages: [UIImage] = []
        @State private var previousImages: [UIImage?] = []
        
        var body: some View {
            PhotoPickerView(selectedItems: $selectedItems, selectedImages: $selectedImages, previousImages: $previousImages, maxSelectedCount: 5)
        }
    }

    static var previews: some View {
        PreviewWrapper()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
