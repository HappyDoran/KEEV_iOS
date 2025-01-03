//
//  VibeModifyScreen.swift
//  KEEV
//
//  Created by 김준성 on 11/19/24.
//

import SwiftUI
import PhotosUI

struct VibeModifyScreen: View {
    @Injected private var service: any VibeServiceProtocol
    
    private let cache = UIImageCache.shared
    @Environment(\.dismiss) private var dismiss
    @Namespace private var recentPhoto
    
    @Binding private var vibe: VibeUIO
    @State private var rating: Double
    @State private var comment: String
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var previousImages: [UIImage?] = []
    @State private var isDelete = false
    
    private let maxSelectedCount: Int = 5
    private let onUpdate: ((VibeUIO) -> Void)?
    
    @State private var loadingForUpload: Bool = false
    @State private var showCancelAlert = false
    @State private var showExitAlert = false
    @State private var errorForAlert: Error? = nil
    
    init(vibe: Binding<VibeUIO>, onUpdate: ((VibeUIO) -> Void)? = nil) {
        self._vibe = vibe
        self.onUpdate = onUpdate
        let wrappedVibe = vibe.wrappedValue
        self.rating = wrappedVibe.rating
        self.comment = wrappedVibe.comment ?? ""
        self.selectedItems = selectedItems
        self.selectedImages = selectedImages
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VibeEventCell(event: vibe.event, onClick: nil)
                .padding(EdgeInsets(top: 28, leading: 16, bottom: 36, trailing: 16))
            
            ScrollView(showsIndicators: false){
                VStack(spacing : 0) {
                    // MARK: 만족도 뷰
                    ratingSection
                    Rectangle().fill(.gray800).frame(height: 1)
                    
                    // MARK: 사진 선택 뷰
                    photoPickerSection
                    Rectangle().fill(.gray800).frame(height: 1)
                    
                    // MARK: 코멘트 뷰
                    commentSection
                }
            }
            .background(Color.grayBG800)
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("글 고치기")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    showExitAlert = true
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.gray100)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: modifyVibe){
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.brand500)
                            .frame(width: 58, height: 32)
                            .opacity(rating == 0 ? 0.2 : 1)
                        
                        Text("완료")
                            .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium)))
                            .foregroundColor(rating == 0 ? .gray700 : .brand50)
                    }
                }
                .disabled(rating == 0)
            }
        }
        .customAlert(
            isPresented: $showExitAlert,
            title: "정말로 나가시겠어요?",
            message: "작성 중인 내용은 저장되지 않아요.",
            firstButtonText: "나가기",
            firstButtonStyle: .destructive,
            firstButtonAction: {
                dismiss()
            },
            secondButtonText: "계속 작성",
            secondButtonStyle: .normal,
            secondButtonAction: { }
        )
        .edgesIgnoringSafeArea(.bottom)
        .backgroundForKEEV()
        .task {
            loadingForUpload = true
            var tempImages = [UIImage?]()
            for url in vibe.imageURLs {
                if let url,
                   let data = try? await URLSession.shared.data(from: url).0,
                   let image = UIImage(data: data) {
                    tempImages.append(image)
                    await cache.remove(for: url)
                } else {
                    tempImages.append(nil)
                }
            }
            previousImages = tempImages
            loadingForUpload = false
        }
        .loading(for: loadingForUpload)
        .alertForError($errorForAlert)
    }
}

private extension VibeModifyScreen {
    var ratingSection: some View {
        VibeRatingCell(rating: $rating)
            .frame(maxWidth: .infinity)
    }
    
    var photoPickerSection: some View {
        VibePhotoPickerCell(selectedItems: $selectedItems, selectedImages: $selectedImages, previousImages: $previousImages, maxSelectedCount: maxSelectedCount)
            .frame(maxWidth: .infinity)
    }
    
    var commentSection: some View {
        VibeCommentCell(comment: $comment, showCancelAlert: $showCancelAlert)
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
    }
}

private extension VibeModifyScreen {
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
                    print(error.localizedDescription)
                }
            }
            selectedImages = tempPhotos
        }
    }
    
    func modifyVibe() {
        loadingForUpload = true
        let previousImages = previousImages.compactMap(\.self)
        Task {
            do {
                let uploadedVibe = try await service.modifyVibe(
                    vibeID: vibe.id,
                    rating: rating,
                    comment: comment.isEmpty ? nil : comment,
                    previousImageURLs: [],
                    images: previousImages + selectedImages
                )
                vibe = uploadedVibe
                onUpdate?(uploadedVibe)
                dismiss()
            } catch {
                errorForAlert = error
                print("바이브를 수정하는데 실패했어요.")
            }
            loadingForUpload = false
        }
    }
}

#Preview {
    NavigationStack {
        VibeModifyScreen(vibe: .constant(.dummy2))
    }
}
