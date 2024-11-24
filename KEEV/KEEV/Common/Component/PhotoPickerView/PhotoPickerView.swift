import SwiftUI
import PhotosUI

/// PhotoPicker를 사용하여 사진을 첨부, 삭제, 수정을 하는 구조체
///
/// - `selectedItems`:  picker에서 선택하는 Item, Picker에서 check되는 PhotosPickerItem 타입 배열
/// - `selectedImages`: UI에서 실제로 보여지는 이미지 타입 배열
/// - `maxSelectedCount`: 최대 이미지 수. 5장으로 고정
///
/// - Note: picker에서 Add 버튼 클릭시 SelectedItems가 변하게 되어 onChange modifier가 실행된다.
/// 이때 추가를 해주는 방식이 아닌 selectedItems를 빈 배열로 만들고 선택된 PhotosPickerItems를 형변환 하여 append 한다.
///  Image의 수에 따라서 빈 RoundRectangle이 Image로 바뀌는 형식으로 구현되었다.
/// - Author: Doran
struct PhotoPickerView: View {
    @Binding private var selectedItems: [PhotosPickerItem]
    @Binding private var selectedImages: [UIImage]
    private let maxSelectedCount: Int
    
    private var availableSelectedCount: Int {
        maxSelectedCount - selectedImages.count
    }
    
    init(selectedItems: Binding<[PhotosPickerItem]>, selectedImages: Binding<[UIImage]>, maxSelectedCount: Int) {
        self._selectedItems = selectedItems
        self._selectedImages = selectedImages
        self.maxSelectedCount = maxSelectedCount
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
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.grayBG700)
                        .overlay{
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.gray500)
                        }
                }
                
                // MARK: 이미지가 있을 때는 이미지, 이미지가 없을 때는 빈 사각형을 띄우는 뷰
                ForEach(0..<maxSelectedCount, id: \.self) { index in
                    if index < selectedImages.count {
                        ZStack {
                            Image(uiImage: selectedImages[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(16)
                                .overlay(
                                    Button(action: {
                                        deleteImage(at: index)
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.white.opacity(0.8))
                                            .frame(width: 20, height: 20)
                                    }
                                        .padding(8),
                                    alignment: .topTrailing
                                )
                        }
                    }
                }
            }
        }
        .onChange(of: selectedItems) { _, _ in
            handleSelectedPhotos()
        }
    }
}



extension PhotoPickerView {
    // MARK: photoPicker에서 add 이벤트 완료 시 발생하는 함수
    private func handleSelectedPhotos() {
        Task {
            selectedImages.removeAll()
            for item in selectedItems {
                do {
                    if let data = try await item.loadTransferable(type: Data.self)
                        , let newImage = UIImage(data: data) {
                        selectedImages.append(newImage)   
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: 이미지 삭제
    private func deleteImage(at index: Int) {
        guard index < selectedImages.count, index < selectedItems.count else { return }
        selectedItems.remove(at: index)
    }
}

struct PhotoPickerView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var selectedItems: [PhotosPickerItem] = []
        @State private var selectedImages: [UIImage] = []
        @State private var isPresentedError: Bool = false

        var body: some View {
            PhotoPickerView(selectedItems: $selectedItems, selectedImages: $selectedImages, maxSelectedCount: 5)
        }
    }

    static var previews: some View {
        PreviewWrapper()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
