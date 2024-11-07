//
//  VibeCreateScreen.swift
//  KEEV
//
//  Created by Doran on 11/5/24.
//

import SwiftUI
import PhotosUI

struct VibeCreateScreen: View {
    @State private var isPresented = false
    
    // MARK: 이벤트 정보, 선택한 사진, 점수
    @State private var selectedEvent: EventDTO? = EventDTO(id: "1", title: "AAA TOUR BY HYUKOH & SUNSET ROLLERCOASTER", startDate: "2024. 10. 4", endDate: "2024. 10. 6", place: "홍대 일대", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF251812_241021_161408.png")
//    @State private var selectedEvent: EventDTO? = nil
    
    @State private var rating: Double = 0
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    private let maxSelectedCount: Int = 5
    
    @State private var comment: String = ""
    
    
    var body: some View {
        VStack(spacing: 0) {
            VibeHeader(selectedEvent: selectedEvent, rating: rating).padding(.horizontal, 16)
            
            if let event = selectedEvent {
                VStack(spacing: 0){
                    VibeEventCell(event: event){
                        isPresented.toggle()
                    }
                    .padding(EdgeInsets(top: 28, leading: 16, bottom: 36, trailing: 16))
                    
                    ScrollView {
                        VStack(spacing : 0) {
                            ratingSection
                            Rectangle().fill(.gray800).frame(height: 1)
                            
                            photoPickerSection
                            Rectangle().fill(.gray800).frame(height: 1)
                            
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
        VibeCommentCell(comment: $comment)
            .padding(.horizontal, 16)
    }
}

#Preview {
    VibeCreateScreen()
}
