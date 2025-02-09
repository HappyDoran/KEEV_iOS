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
    private var proxy: ScrollViewProxy?
    
    init(selectedEvent: Binding<SimpleEventUIO?> = Binding.constant(nil), proxy: ScrollViewProxy? = nil) {
        self._selectedEvent = selectedEvent
        self.proxy = proxy
    }
    
    var body: some View {
        // MARK: 로고 이미지
        HStack(spacing: 0) {
            Button {
                withAnimation {
                    proxy?.scrollTo(0)
                }
            } label: {
                Image("LogoImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 32)
            }
            
            Spacer()
        }
        .frame(height: 48)
        .padding(.horizontal, 16)
    }
}

#Preview {
    MainHeader()
        .backgroundForKEEV()
}
