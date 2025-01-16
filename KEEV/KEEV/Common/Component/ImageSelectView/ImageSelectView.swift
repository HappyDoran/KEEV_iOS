//
//  ImageSelectView.swift
//  KEEV
//
//  Created by Doran on 10/28/24.
//

import SwiftUI
import PhotosUI

/// 프로필 사진이나 배경사진을 선택할 때 나오는 PhotosPicker
///
/// - `image`: 프로필 이미지
///
/// 프로필 사진이나 배경사진 수정 시 sheet 혹은 fullScreenCover로 나오는 PhotosPicker입니다.
///
/// 사용방법은 아래와 같습니다.
///
/// 최상단 뷰에 actionSheetForKEEV 모디파이어와 sheet 혹은 fullScreenCover 모디파이어를 사용하고 sheet 혹은 fullScreenCover 모디파이어에 본 뷰를 추가해줍니다.
///
/// ```swift
/// VStack { ... }
/// .actionSheetForKEEV(isPresented: $showActionSheet, defaults: .setProfileImage(modifyHandler: {
/// showImageSelectSheet = true
/// }, deleteHandler: {
/// profileImage = nil
/// showActionSheet = false
/// }))
/// .fullScreenCover(isPresented: $showImageSelectSheet) {
/// ImageSelectView(image: $profileImage)
///     .onDisappear {
///         showActionSheet = false
///     }
/// }
/// ```
///
/// - Author: Doran, 라움
struct ImageSelectView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @Binding var image: UIImage?
    
    var body: some View {
        ImagePicker(image: $image)
    }
}

extension ImageSelectView {
    private struct ImagePicker: UIViewControllerRepresentable {
        typealias UIViewControllerType = UIImagePickerController
        
        @Binding var image: UIImage?
        @Environment(\.dismiss) var dismiss
        
        func makeCoordinator() -> Coordinator {
            ImageSelectView.Coordinator(self)
        }
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let controller = UIImagePickerController()
            controller.delegate = context.coordinator
            return controller
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
            
        }
    }
}

extension ImageSelectView {
    private class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else { return }
            parent.image = image
            parent.dismiss()
        }
    }
}

#Preview {
    ImageSelectView(image: .constant(UIImage(named: "sample")))
}
