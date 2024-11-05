//
//  ProfileEditTopView.swift
//  KEEV
//
//  Created by Yune Cho on 11/5/24.
//

import SwiftUI

struct ProfileEditTopView: View {
    @Binding var showCloseAlert: Bool
    
    var body: some View {
        HStack {
            Button {
                showCloseAlert = true
            } label: {
                VStack(alignment: .leading) {
                    Image(systemName: "xmark")
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray100)
                }
            }
            .frame(width: 58, height: 32)
            
            Spacer()
            
            Text("프로필 수정")
                .figmaFont(PretendardFont.title(style: .xs))
                .foregroundStyle(.gray100)
            
            Spacer()
            
            Rectangle()
                .frame(width: 58, height: 32)
                .foregroundStyle(.clear)
        }
    }
}

#Preview {
    ProfileEditTopView(showCloseAlert: .constant(false))
}
