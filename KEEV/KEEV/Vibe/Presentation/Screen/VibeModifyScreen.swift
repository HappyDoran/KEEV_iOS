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
    
    @Binding private var vibe: VibeUIO
    @State private var rating: Double
    @State private var comment: String
    @State private var previousImages: [URL?]
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    private let maxSelectedCount: Int = 5
    
    @State private var showCancelAlert = false
    @State private var showExitAlert = false
    
    init(vibe: Binding<VibeUIO>) {
        self._vibe = vibe
        let wrappedVibe = vibe.wrappedValue
        self.rating = wrappedVibe.rating
        self.comment = wrappedVibe.comment ?? ""
        self.previousImages = wrappedVibe.imageURLs
        self.selectedItems = selectedItems
        self.selectedImages = selectedImages
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VibeHeader(selectedEvent: vibe.event, rating: rating, showExitAlert: $showExitAlert)
                .padding(.horizontal, 16)
            
            VibeEventCell(event: vibe.event, onClick: nil)
                .padding(EdgeInsets(top: 28, leading: 16, bottom: 36, trailing: 16))
            
            ScrollView {
                VStack(spacing : 0) {
                    // MARK: 만족도 뷰
                    ratingSection
                    Rectangle().fill(.gray800).frame(height: 1)
                    
                    previousPhotoSection
                    Rectangle().fill(.gray800).frame(height: 1)
                    
                    // MARK: 사진 선택 뷰
                    photoPickerSection
                    Rectangle().fill(.gray800).frame(height: 1)
                    
                    // MARK: 코멘트 뷰
                    commentSection
                }
            }
            .background(Color.gray900)
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
    }
}

private extension VibeModifyScreen {
    var ratingSection: some View {
        VibeRatingCell(rating: $rating)
            .frame(maxWidth: .infinity)
    }
    
    private var previousPhotoSection: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0){
                Text("이미 저장된 사진")
                    .figmaFont(PretendardFont.title(style: .xs))
                    .foregroundColor(.gray50)
                Spacer()
                Text("\(previousImages.count) 장")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                    .foregroundColor(.gray500)
            }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<previousImages.count, id: \.self) { index in
                        URLCachedImage(url: previousImages[index]) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                            } else if phase.error == nil {
                                ProgressView()
                                    .frame(width: 100, height: 100)
                            } else {
                                let _ = print(phase.error!)
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            }
                        }
                        .mask(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            Button(action: {
                                previousImages.remove(at: index)
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
            .padding(EdgeInsets(top: 12, leading: 16, bottom: 16, trailing: 0))
        }
    }
    
    var photoPickerSection: some View {
        VibePhotoPickerCell(selectedItems: $selectedItems, selectedImages: $selectedImages, maxSelectedCount: maxSelectedCount - previousImages.count)
            .frame(maxWidth: .infinity)
    }
    
    var commentSection: some View {
        VibeCommentCell(comment: $comment, showCancelAlert: $showCancelAlert)
            .padding(.horizontal, 16)
            .padding(.bottom, 69)
    }
}

#Preview {
    VibeModifyScreen(vibe: .constant(.dummy0))
}
