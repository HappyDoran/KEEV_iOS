//
//  TermsOfUseView.swift
//  KEEV
//
//  Created by Yune Cho on 11/9/24.
//

import SwiftUI

struct TermsOfUseView: View {
    @State private var termsOfUse = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            FullScreenCoverTopView(title: "서비스 이용약관")
            
            if termsOfUse.isEmpty {
                Spacer()
                HStack {
                    Spacer()
                    ProgressView()
                        .tint(.brand500)
                    Spacer()
                }
                Spacer()
            } else {
                ScrollView {
                    Text(termsOfUse)
                }
                .foregroundStyle(.gray500)
                .padding(.horizontal, 16)
            }
        }
        .backgroundForKEEV()
        .onAppear {
            let detachedTask = Task.detached(priority: .background) {
                do {
                    try await loadData()
                } catch {
                    print("서비스 이용약관을 불러오는 중에 오류가 발생했습니다.")
                }
            }
            detachedTask.cancel()
        }
    }
}

extension TermsOfUseView {
    private func loadData() async throws {
        let filepath = Bundle.main.url(forResource: "TermsOfUse", withExtension: "txt")!
        
        do {
            try termsOfUse = String(contentsOf: filepath, encoding: .utf8)
        } catch {
            throw error
        }
    }
}

#Preview {
    TermsOfUseView()
}
