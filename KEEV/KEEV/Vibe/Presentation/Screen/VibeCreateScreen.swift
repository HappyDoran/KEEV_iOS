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
    @EnvironmentObject private var vibeManager: VibeManager
    @Injected private var service: any VibeServiceProtocol
    
    @State private var loadingForUpload: Bool = false // 바이브 업로드할 때 뜨는 로딩
    @State private var isPresented = false
    @State private var errorForAlert: Error? = nil
    @State private var selectedEvent: SimpleEventUIO?
    @State private var rating: Double = 0
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    
    private let maxSelectedCount: Int = 5
    private let onCreate: ((VibeUIO) -> Void)?
    
    @State private var comment: String = ""
    @State private var showCancelAlert = false
    @State private var showExitAlert = false
    let isNavigation: Bool
    
    init(selectedEvent: SimpleEventUIO?,
         isNavigation: Bool,
         onCreate: ((VibeUIO) -> Void)? = nil) {
        self._selectedEvent = .init(wrappedValue: selectedEvent)
        self.isNavigation = isNavigation
        self.onCreate = onCreate
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: 헤더
            if !isNavigation {
                VibeHeader(selectedEvent: selectedEvent, rating: rating, showExitAlert: $showExitAlert) {
                    uploadVibe()
                }
                .padding(.horizontal, 16)
            }
            
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
                    .scrollDisabled(selectedEvent == nil)
                    .background(Color.grayBG800)
                }
            }
            
            else {
                VStack(spacing : 0) {
                    EventSelectCell(isPresented: $isPresented)
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 24, trailing: 16))
                    ScrollView {
                        ratingSection
                        
                        Rectangle().fill(.gray800).frame(height: 1)
                        
                        photoPickerSection
                        
                        Rectangle().fill(.gray800).frame(height: 1)
                        
                        commentSection
                    }
                    .opacity(selectedEvent == nil ? 0.2 : 1)
                    .disabled(selectedEvent == nil)
                }
                .scrollDisabled(false)
            }
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
        .loading(for: loadingForUpload)
        .alertForError($errorForAlert)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    if selectedEvent != nil {
                        showExitAlert = true
                    } else {
                        dismiss()
                    }
                }) {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.gray100)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("글쓰기")
                    .figmaFont(PretendardFont.title(style: .xs))
                    .foregroundColor(.gray100)
            }
            
            if selectedEvent != nil {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: uploadVibe) {
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
        }
    }
}

extension VibeCreateScreen {
    private var ratingSection: some View {
        VibeRatingCell(rating: $rating)
            .frame(maxWidth: .infinity)
    }
    
    private var photoPickerSection: some View {
        VibePhotoPickerCell(selectedItems: $selectedItems, selectedImages: $selectedImages, previousImages: .constant([]), maxSelectedCount: maxSelectedCount)
            .frame(maxWidth: .infinity)
    }
    
    private var commentSection: some View {
        VibeCommentCell(comment: $comment, showCancelAlert: $showCancelAlert)
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
    }
}

private extension VibeCreateScreen {
    func uploadVibe() {
        guard let selectedEvent else { return }
        loadingForUpload = true
        Task {
            do {
                let newVibe = try await service.uploadVibe(
                    eventID: selectedEvent.id,
                    rating: rating,
                    comment: comment,
                    images: selectedImages
                )
                onCreate?(newVibe)
                dismiss()
            } catch {
                errorForAlert = error
                print("\(error)")
                print(error.localizedDescription)
                print("바이브를 업로드하는데 실패했습니다.")
            }
            loadingForUpload = false
        }
    }
}

#Preview {
    VibeCreateScreen(selectedEvent: nil, isNavigation: false)
}
