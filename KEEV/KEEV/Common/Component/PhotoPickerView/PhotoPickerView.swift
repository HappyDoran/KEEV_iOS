import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    @Binding private var selectedImages: [UIImage]
    @Binding private var isPresentedError: Bool
    private let maxSelectedCount: Int = 5
    
    private var disabled: Bool {
        selectedImages.count >= maxSelectedCount
    }
    private var availableSelectedCount: Int {
        maxSelectedCount - selectedImages.count
    }
    
    init(selectedImages: Binding<[UIImage]>, isPresentedError: Binding<Bool>){
        self._selectedImages = selectedImages
        self._isPresentedError = isPresentedError
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                PhotosPicker(
                    selection: $selectedItems,
                    maxSelectionCount: availableSelectedCount,
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
                        handleSelectedPhotos(newValue)
                    }
                }
                ForEach(selectedImages, id: \.self) { image in
                    ZStack {
                        Image(uiImage: image)
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
    private func handleSelectedPhotos(_ newPhotos: [PhotosPickerItem]) {
        for newPhoto in newPhotos {
            newPhoto.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data, let newImage = UIImage(data: data) {
                        if !selectedImages.contains(where: { $0.pngData() == newImage.pngData() }) {
                            DispatchQueue.main.async {
                                selectedImages.append(newImage)
                            }
                        }
                    }
                case .failure:
                    isPresentedError = true
                }
            }
        }
        selectedItems.removeAll()
    }
}

struct PhotoPickerView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var selectedImages: [UIImage] = []
        @State private var isPresentedError: Bool = false

        var body: some View {
            PhotoPickerView(selectedImages: $selectedImages, isPresentedError: $isPresentedError)
        }
    }

    static var previews: some View {
        PreviewWrapper()
            .preferredColorScheme(.light) // 또는 .dark
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
