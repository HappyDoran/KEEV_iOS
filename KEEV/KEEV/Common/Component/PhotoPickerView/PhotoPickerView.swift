import SwiftUI
import PhotosUI

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
                                Text("\(selectedImages.count)")
                                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                                    .foregroundColor(.gray300)
                                
                                Text(" / 5")
                                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                                    .foregroundColor(.gray500)
                            }
                        }
                    }
                    .onChange(of: selectedItems) { _, _ in
                        handleSelectedPhotos()
                    }
                }

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
    
    private func deleteImage(at index: Int) {
        guard index < selectedImages.count, index < selectedItems.count else { return }
        selectedImages.remove(at: index)
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
