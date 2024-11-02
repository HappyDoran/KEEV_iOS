//
//  SignUpCompleteView.swift
//  KEEV
//
//  Created by Yune Cho on 10/31/24.
//

import SwiftUI

struct SignUpCompleteView: View {
    @Binding var email: String
    @Binding var nickname: String
    @Binding var profileImage: UIImage?
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("환영합니다!")
                .figmaFont(PretendardFont.title(style: .lg))
                .foregroundStyle(.brand500)
                .padding(.bottom, 12)
            
            Text("다양한 공연의 즐거움과 바이브를 느껴보세요!")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium)))
                .foregroundStyle(.gray300)
            
            ZStack{
                if profileImage != nil {
                    Image(uiImage: profileImage!)
                        .resizable()
                        .frame(width: 140, height: 140)
                        .scaledToFit()
                        .clipShape(Circle())
                }
                else {
                    Circle()
                        .frame(width: 140,height: 140)
                        .foregroundColor(.gray900)
                    
                    Image("ProfileImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 101.12, height: 114.5)
                        .padding(.top, 25.9)
                }
            }
            .padding(.top, 100)
            .padding(.bottom, 12)
            
            Text(nickname)
                .figmaFont(PretendardFont.title(style: .sm))
                .padding(.bottom, 4)
            
            Text(email)
                .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .medium)))
        }
    }
}

#Preview {
    SignUpCompleteView(email: .constant("keev@email.com"), nickname: .constant("Keev"), profileImage: .constant(nil))
}
