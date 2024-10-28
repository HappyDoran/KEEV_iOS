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
    @State private var selectedItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()
    private let maxSelectedCount: Int = 5
    
    private var disabled: Bool {
        selectedImages.count >= maxSelectedCount
    }
    
    private var availableSelectedCount: Int {
        maxSelectedCount - selectedImages.count
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
                        VStack(spacing: 8) {
                            Image(systemName: "camera.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 45, height: 29)
                                .foregroundColor(.gray500)
                            
                            HStack(spacing: 0) {
                                Text("\(selectedItems.count)")
                                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                                    .foregroundColor(.gray300)
                                
                                Text(" / \(maxSelectedCount)")
                                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                                    .foregroundColor(.gray500)
                            }
                        }
                    }
                    .onChange(of: selectedItems) { _, _ in
                        handleSelectedPhotos()
                    }
                }
                
                // MARK: 이미지 뷰
                ForEach(selectedImages.indices, id: \.self) { index in
                    ZStack {
                        selectedImages[index]
                            .resizable()
                            .scaledToFill()
                            .frame(width: 112, height: 112)
                            .cornerRadius(16)
                            .overlay(
                                Button(action: {
                                    deleteImage(at: index)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray300).opacity(0.7)
                                        .font(.title)
                                }
                                .padding(8),
                                alignment: .topTrailing
                            )
                    }
                }
                
                // MARK: 이미지가 없을 때의 사각형 뷰
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
    // MARK: photoPicker에서 add 이벤트 완료 시 발생하는 함수
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
    
    // MARK: 이미지 삭제
    private func deleteImage(at index: Int) {
        guard index < selectedImages.count, index < selectedItems.count else { return }
        selectedItems.remove(at: index)
    }
}

struct PhotoPickerView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var selectedImages: [UIImage] = []
        @State private var isPresentedError: Bool = false

        var body: some View {
            PhotoPickerView()
        }
    }

    static var previews: some View {
        PreviewWrapper()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
