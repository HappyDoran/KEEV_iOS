//
//  SearchHeader.swift
//  KEEV
//
//  Created by Doran on 11/2/24.
//

import SwiftUI

struct SearchHeader: View {
    @Binding private var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    var body: some View {
        ZStack {
            Text("검색").figmaFont(PretendardFont.title(style: .xs)).foregroundColor(.gray100)
            
            HStack {
                Spacer()
                Button(action: {
                    isPresented.toggle()
                }) {
                    Text("취소").figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .regular))).foregroundColor(.brand500)
                }
            }
            .padding(.trailing, 16)
            .frame(height: 48)
        }
    }
}

#Preview {
    SearchHeader(isPresented: .constant(false))
        .backgroundForKEEV()
}
