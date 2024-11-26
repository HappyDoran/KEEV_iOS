//
//  HeaderView.swift
//  KEEV
//
//  Created by Doran on 11/1/24.
//

import SwiftUI

/// 이벤트 정보, 홈화면에 들어가는 헤더
///
/// 돋보기 버튼 클릭시 풀스크린 시트가 올라가면서 EventSearchScreen이 생성됩니다.
///
/// - Author: Doran
struct MainHeader: View {
    @Binding private var selectedEvent: SimpleEventUIO?
    
    init(selectedEvent: Binding<SimpleEventUIO?> = Binding.constant(nil)) {
        self._selectedEvent = selectedEvent
    }
    
    var body: some View {
        // MARK: 로고 이미지
        HStack(spacing: 0) {
            Image("LogoImage")
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 32)
            
            Spacer()
            
            // MARK: 검색 시트 위로 올리는 버튼
            NavigationLink {
                TotalSearchScreen()
            } label: {
                Image(systemName: "magnifyingglass")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xlarge, bodyWeight: .semibold)))
                    .font(.system(size: 20))
                    .foregroundColor(Color.gray100)
            }
        }
        .backgroundForKEEV()
        .frame(height: 48)
        .padding(.horizontal, 16)
    }
}

#Preview {
    MainHeader()
        .backgroundForKEEV()
}
