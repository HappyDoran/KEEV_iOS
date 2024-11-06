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
    
    
    var body: some View {
        VStack(spacing: 0) {
            VibeHeader()
            
            if let event = selectedEvent {
                VibeEventCell(event: event){
                    isPresented.toggle()
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
                
                ratingSection
                    .padding(.top, 36)
                Rectangle().fill(Color.gray800).frame(height: 1)
                
                photoPickerSection
                
                Rectangle().fill(Color.gray800).frame(height: 1)
            }
            else {
                EventSelectCell(isPresented: $isPresented)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                
            }
            
            Spacer()
        }
        .fullScreenCover(isPresented: $isPresented) {
            SearchScreen(selectedEvent: $selectedEvent, searchContent: .vibe)
        }
        .backgroundForKEEV()
    }
}

extension VibeCreateScreen {
    private var ratingSection: some View {
        VibeRatingCell(rating: $rating)
            .frame(height: 141)
            .frame(maxWidth: .infinity)
            .background(Color.gray900)
    }
    
    private var photoPickerSection: some View {
        VibePhotoPickerCell(selectedItems: $selectedItems, selectedImages: $selectedImages, maxSelectedCount: maxSelectedCount)            
            .frame(height: 166)
            .frame(maxWidth: .infinity)
            .background(Color.gray900)
    }
}

#Preview {
    VibeCreateScreen()
}
