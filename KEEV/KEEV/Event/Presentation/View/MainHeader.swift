//
//  HeaderView.swift
//  KEEV
//
//  Created by Doran on 11/1/24.
//

import SwiftUI

/// 이벤트 정보, 홈화면에 들어가는 헤더
///
/// - Author: Doran
struct MainHeader: View {
    @State private var isPresented: Bool = false
    
    var body: some View {
        // MARK: 로고 이미지
        HStack(spacing: 0) {
            Image("LogoImage")
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 32)
            
            Spacer()
            
            // MARK: 검색 시트 위로 올리는 버튼
            Button(action: {
                isPresented.toggle()
            }) {
                Image(systemName: "magnifyingglass")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xlarge, bodyWeight: .semibold)))
                    .font(.system(size: 20))
                    .foregroundColor(Color.gray100)
            }
            .fullScreenCover(isPresented: $isPresented){
                EventSearchScreen(isPresented: $isPresented)
                
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
