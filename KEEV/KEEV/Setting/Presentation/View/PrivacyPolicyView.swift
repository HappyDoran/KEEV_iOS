//
//  PrivacyPolicyView.swift
//  KEEV
//
//  Created by Yune Cho on 11/9/24.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @State private var privacyPolicy = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            FullScreenCoverTopView(title: "개인정보 처리방침")
            
            if privacyPolicy.isEmpty {
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
                    Text(privacyPolicy)
                }
                .foregroundStyle(.gray500)
                .padding(.horizontal, 16)
            }
        }
        .backgroundForKEEV()
        .onAppear {
            let detachedTask = Task.detached {
                do {
                    try await loadData()
                } catch {
                    print("개인정보 처리방침을 불러오는 중에 오류가 발생했습니다.")
                }
            }
            detachedTask.cancel()
        }
    }
}

extension PrivacyPolicyView {
    private func loadData() async throws {
        let filepath = Bundle.main.url(forResource: "PrivacyPolicy", withExtension: "txt")!
        
        do {
            try privacyPolicy = String(contentsOf: filepath, encoding: .utf8)
        } catch {
            throw error
        }
    }
}

#Preview {
    PrivacyPolicyView()
}
