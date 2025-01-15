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
    let nickname: String
    let profileImage: UIImage?
    @Binding var currentPage: SignUpPage
    let finishSignUp: () -> Void
    
    var body: some View {
        VStack {
            ZStack {
                LottieView(animation: .named("SignUpCompleteLottie"))
                    .playing(loopMode: .loop)
                    .frame(height: 250)
                    .padding()
                
                VStack(alignment: .center) {
                    VStack(spacing: 12) {
                        Text("환영합니다!")
                            .figmaFont(PretendardFont.title(style: .lg))
                            .foregroundStyle(.brand500)
                        
                        Text("다양한 공연의 즐거움과 바이브를 느껴보세요!")
                            .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium)))
                            .foregroundStyle(.gray300)
                    }
                    
                    VStack(spacing: 0) {
                        ProfileImage(profileImage: profileImage, size: 140, editable: false)
                            .padding(.top, 100)
                            .padding(.bottom, 12)
                        
                        Text(nickname)
                            .figmaFont(PretendardFont.title(style: .sm))
                            .foregroundStyle(.gray50)
                            .padding(.bottom, 4)
                    }
                }
            }
        }
        .padding(.top, 40)
        .padding(.horizontal, 24)
        
        Spacer()
        
        CommonButton(
            title: "시작하기",
            action: {
                finishSignUp()
            },
            style: .maxWidth
        )
        .sensoryFeedback(.success, trigger: currentPage)
        .padding(.top, 12)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}

#Preview {
    SignUpCompleteView(nickname: "hi", profileImage: nil, currentPage: .constant(.complete)) { }
}
