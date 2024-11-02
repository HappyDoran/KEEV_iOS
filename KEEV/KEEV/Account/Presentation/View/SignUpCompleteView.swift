//
//  SignUpCompleteView.swift
//  KEEV
//
//  Created by Yune Cho on 10/31/24.
//

import SwiftUI
import Lottie

/// 회원가입 완료 뷰
///
/// 회원가입이 완료되었을 때 보여주는 뷰로 입력한 이메일, 닉네임, 프로필 사진과 함께 환영문구를 보여줍니다.
///
/// - Author: 라움
struct SignUpCompleteView: View {
    @ObservedObject var accountService: AccountService
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                Text("환영합니다!")
                    .figmaFont(PretendardFont.title(style: .lg))
                    .foregroundStyle(.brand500)
                    .padding(.bottom, 12)
                
                Text("다양한 공연의 즐거움과 바이브를 느껴보세요!")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium)))
                    .foregroundStyle(.gray300)
                
                ProfileImage(profileImage: $accountService.profileImage, editable: false)
                    .padding(.top, 100)
                    .padding(.bottom, 12)
                
                Text(accountService.nickname)
                    .figmaFont(PretendardFont.title(style: .sm))
                    .foregroundStyle(.gray100)
                    .padding(.bottom, 4)
                
                Text(accountService.email)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .medium)))
                    .foregroundStyle(.gray300)
            }
            
            LottieView(animation: .named("SignUpCompleteLottie"))
                .playing()
                .frame(height: 250)
                .padding()
        }
    }
}

#Preview {
    SignUpCompleteView(accountService: AccountService())
}
