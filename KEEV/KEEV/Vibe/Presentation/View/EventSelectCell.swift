//
//  EventSelectCell.swift
//  KEEV
//
//  Created by Doran on 11/6/24.
//

import SwiftUI

/// 이벤트 선택 버튼 셀
///
/// - Parameters:
///   - isPresented: 시트 여부 Bool 타입
///
/// - Author: Doran
struct EventSelectCell: View {
    @Binding private var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    var body: some View {
        Button(action: {
            isPresented.toggle()
        }){
            ZStack{
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 106)
                    .foregroundColor(.grayBG700)
                VStack(spacing: 0){
                    Image(systemName: "newspaper.fill")
                        .figmaFont(PretendardFont.title(style: .lg))
                        .foregroundColor(.gray500)
                    Text("공연을 선택해주세요")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium)))
                        .foregroundColor(.gray50)
                        .padding(.top, 8)
                }
            }
        }
    }
}

#Preview {
    EventSelectCell(isPresented: .constant(true))
}
