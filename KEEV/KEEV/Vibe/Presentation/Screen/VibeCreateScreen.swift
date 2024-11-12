//
//  VibeCreateScreen.swift
//  KEEV
//
//  Created by Doran on 11/5/24.
//

import SwiftUI
import PhotosUI

/// 바이브(글쓰기) 작성 스크린
///
/// - Note: 공연 선택이 안됐을 때 버튼 하단의 뷰가 확정되지 않아 일단 피그마대로 집어 넣었습니다. 피그마 수정시 수정될 것입니다.
///
/// - Author: Doran
struct VibeCreateScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var isPresented = false
    
    @State private var selectedEvent: EventDTO? = nil
    
    @State private var rating: Double = 0
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    private let maxSelectedCount: Int = 5
    
    @State private var comment: String = ""
    @State private var showCancelAlert = false
    @State private var showExitAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: 헤더
            VibeHeader(selectedEvent: selectedEvent, rating: rating, showExitAlert: $showExitAlert)
                .padding(.horizontal, 16)
            
            if let event = selectedEvent {
                VStack(spacing: 0){
                    // MARK: 선택한 이벤트 표시 뷰
                    VibeEventCell(event: event){
                        isPresented.toggle()
                    }
                    .padding(EdgeInsets(top: 28, leading: 16, bottom: 36, trailing: 16))
                    
                    ScrollView {
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
                    .background(Color.gray900)
                }
            }
            
            else {
                EventSelectCell(isPresented: $isPresented)
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 24, trailing: 16))
                
                VStack(spacing : 0) {
                    ratingSection

                    Rectangle().fill(.gray800).frame(height: 1)
                    
                    photoPickerSection

                    Rectangle().fill(.gray800).frame(height: 1)
                    
                    commentSection

                }
                .opacity(selectedEvent == nil ? 0.2 : 1)
                .disabled(selectedEvent == nil)
            }
            
            Spacer()
        }
        .fullScreenCover(isPresented: $isPresented) {
            SearchScreen(selectedEvent: $selectedEvent, searchContent: .vibe)
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

extension VibeCreateScreen {
    private var ratingSection: some View {
        VibeRatingCell(rating: $rating)
            .frame(maxWidth: .infinity)
    }
    
    private var photoPickerSection: some View {
        VibePhotoPickerCell(selectedItems: $selectedItems, selectedImages: $selectedImages, maxSelectedCount: maxSelectedCount)
            .frame(maxWidth: .infinity)
    }
    
    private var commentSection: some View {
        VibeCommentCell(comment: $comment, showCancelAlert: $showCancelAlert)
            .padding(.horizontal, 16)
            .padding(.bottom, 69)
    }
}

#Preview {
    VibeCreateScreen()
}
