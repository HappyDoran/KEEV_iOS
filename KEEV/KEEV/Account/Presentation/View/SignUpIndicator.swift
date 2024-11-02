//
//  SignUpIndicator.swift
//  KEEV
//
//  Created by Yune Cho on 10/31/24.
//

import SwiftUI

struct SignUpIndicator: View {
    @Binding var currentPage: SignUpPage
    @Binding var progress: Double
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    // navigationRouter로 로그인 화면으로 돌아가면 됩니다.
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.gray300)
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
                            
                            Text(" / 3")
                                .foregroundStyle(.brand500)
                                .opacity(0.5)
                        }
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                    }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            
            ProgressView(value: progress)
                .tint(.brand500)
                .background(.gray800)
                .animation(.easeInOut, value: progress)
        }
        .onChange(of: currentPage) {
            progress = Double(currentPage.rawValue) / 3
        }
    }
}

#Preview {
    SignUpIndicator(currentPage: .constant(.email), progress: .constant(0.33))
}
