//
//  VibeModifyScreen.swift
//  KEEV
//
//  Created by 김준성 on 11/19/24.
//

import SwiftUI
import PhotosUI

struct VibeModifyScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Namespace private var recentPhoto
    
    @Binding private var vibe: VibeUIO
    @State private var rating: Double
    @State private var comment: String
    @State private var previousImages: [UIImage?] = []
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var isDelete = false
    private let maxSelectedCount: Int = 5
    
    @State private var showCancelAlert = false
    @State private var showExitAlert = false
    
    init(vibe: Binding<VibeUIO>) {
        self._vibe = vibe
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
            
            ScrollView {
                VStack(spacing : 0) {
                    // MARK: 만족도 뷰
                    ratingSection
                    Rectangle().fill(.gray800).frame(height: 1)
                    
                    // MARK: 사진 선택 뷰
                    VStack(spacing: 12) {
                        photoHeader
                        photoPickerContent
                    }
                    .padding(16)
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
                        .foregroundStyle(.gray100)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    // 수정하는 로직 추가
                    // 
                    dismiss()
                }){
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
            var tempImages = [UIImage?]()
            for url in vibe.imageURLs {
                if let url,
                   let data = try? await URLSession.shared.data(from: url).0,
                   let image = UIImage(data: data) {
                    tempImages.append(image)
                } else {
                    tempImages.append(nil)
                }
            }
            previousImages = tempImages
        }
    }
}

private extension VibeModifyScreen {
    var ratingSection: some View {
        VibeRatingCell(rating: $rating)
            .frame(maxWidth: .infinity)
    }
    
    var photoPickerContent: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    PhotosPicker(
                        selection: $selectedItems,
                        maxSelectionCount: maxSelectedCount - previousImages.count,
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
    
    var photoHeader: some View {
        HStack(spacing: 0){
            Text("사진")
                .figmaFont(PretendardFont.title(style: .xs))
                .foregroundColor(.gray50)
            Spacer()
            Text("\(previousImages.count + selectedImages.count) / \(maxSelectedCount)장")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                .foregroundColor(.gray500)
        }
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
}

#Preview {
    VibeModifyScreen(vibe: .constant(.dummy2))
}
