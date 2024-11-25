//
//  VibeHeader.swift
//  KEEV
//
//  Created by Doran on 11/6/24.
//

import SwiftUI
/// VibeCreateScreen 헤더 셀
///
/// - Parameters:
///   - selectedEvent: 선택한 이벤트 여부에 따른 완료 버튼 유무 표시
///   - rating: 만족도 점수에 따른 완료 버튼 활성화
///   - showExitAlert: 글쓰기 화면에서 X버튼 선택 시의 알럿 노출 여부
///
/// - Author: Doran
struct VibeHeader: View {
    private let selectedEvent: SimpleEventUIO?
    private let rating: Double
    @Binding private var showExitAlert: Bool
    
    init(selectedEvent: SimpleEventUIO?, rating: Double, showExitAlert: Binding<Bool>) {
        self.selectedEvent = selectedEvent
        self.rating = rating
        self._showExitAlert = showExitAlert
    }
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Text("글쓰기")
                .figmaFont(PretendardFont.title(style: .xs)).foregroundColor(.gray100)
            
            // MARK: 검색 시트 아래로 내리는 버튼
            HStack {
                Button(action: {
                    showExitAlert = true
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.gray100)
                }
                Spacer()
                
                
                if selectedEvent != nil {
                    Button(action: {
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
            .frame(height: 48)
        }
    }
}

#Preview {
    VibeHeader(selectedEvent:
            .dummy0,
               rating: 0.0,
               showExitAlert: .constant(false)
    )
    .backgroundForKEEV()
}

