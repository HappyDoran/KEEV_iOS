//
//  SignUpIndicator.swift
//  KEEV
//
//  Created by Yune Cho on 10/31/24.
//

import SwiftUI

/// 회원가입 화면 상단 인디케이터
///
/// 회원가입 화면 상단에 위치하며 회원가입 단계와 진행도를 보여주는 인디케이터입니다.
///
/// - Author: 라움
struct SignUpIndicator: View {
    @Binding var signInStatus: SignInStatus?
    @Binding var currentPage: SignUpPage
    @Binding var transitionDirection: Edge
    
    @State private var progress: Double = 1.0 / 2
    
    var body: some View {
        VStack {
            HStack {
                if currentPage != .complete {
                    Button {
                        transitionDirection = .leading
                        signInStatus = .failed
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.gray300)
                    }
                }
                
                Spacer()
                
                Capsule()
                    .frame(width: 60, height: 21)
                    .foregroundStyle(.brand500)
                    .opacity(0.2)
                    .overlay {
                        HStack(spacing: 0) {
                            Text("\(currentPage.rawValue)")
                                .foregroundStyle(.brand400)
                            
                            Text(" / 2")
                                .foregroundStyle(.brand500)
                                .opacity(0.5)
                        }
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                    }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            
            ProgressBar(value: progress, total: 1)
                .animation(.easeInOut, value: progress)
        }
        .onChange(of: currentPage) {
            progress = Double(currentPage.rawValue) / 2
        }
    }
}

#Preview {
    SignUpIndicator(signInStatus: .constant(nil), currentPage: .constant(.profile), transitionDirection: .constant(.leading))
}
