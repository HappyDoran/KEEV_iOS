//
//  HeaderTabView.swift
//  KEEV
//
//  Created by Doran on 11/17/24.
//

import SwiftUI

struct HeaderTabView: View {
    
    @Binding var activeMenu: Menu
    @State private var barX: CGFloat = 0
    private let barHeight: CGFloat = 4
    private let barWidth: CGFloat = 82
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(spacing: 0){
                Text("공연 상세")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .semibold)))
                    .foregroundColor(activeMenu == .menu1 ? .gray50 : .gray500)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        activeMenu = .menu1
                    }
                
                Text("바이브")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .semibold)))
                    .foregroundColor(activeMenu == .menu2 ? .gray50 : .gray500)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        activeMenu = .menu2
                    }
            }
            .frame(height: 46)
            
            Rectangle()
                .fill(Color.brand500)
                .frame(width: barWidth, height: barHeight)
                .offset(x:0, y: 0)
                .offset(x: activeMenu == .menu1 ? -((UIScreen.main.bounds.width / 4)) : (UIScreen.main.bounds.width / 4) , y: 0)
                .animation(.easeInOut, value: activeMenu)
        }
    }
}

#Preview {
    HeaderTabView(activeMenu: .constant(.menu1))
}
