//
//  TermAndCondition.swift
//  KEEV
//
//  Created by 김준성 on 2/14/25.
//

import SwiftUI

/// 이용약관과 개인정보 처리방침 관련 문장을 나타내는 뷰
///
/// - Note: 내부적으로 settingService를 가지고 있습니다. 버튼을 탭하게 되면 자체적으로 sheet를 올립니다.
///
/// - Author: newJunsung
public struct TermAndCondition: View {
    @Injected private var settingService: any SettingServiceProtocol
    
    @State private var state: SheetState? = nil
    
    public var body: some View {
        HStack(spacing: 0) {
            Text("로그인(가입)시 ")
            
            Button {
                state = .termsOfUse
            } label: {
                Text("이용약관")
                    .underline()
                    .baselineOffset(4)
                    .offset(y: 2)
            }
            
            Text(" 및 ")
            
            Button {
                state = .privacyPolicy
            } label: {
                Text("개인정보 처리방침")
                    .underline()
                    .baselineOffset(4)
                    .offset(y: 2)
            }
            
            Text("에 동의하게 됩니다.")
        }
        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall3, bodyWeight: .regular)))
        .foregroundStyle(.gray500)
        .sheet(item: $state) {
            state = nil
        } content: { state in
            DocumentView(title: state.title, text: state.text(from: settingService))
                .presentationDragIndicator(.visible)
                .padding(.top, 16)
                .backgroundForKEEV()
        }
    }
}

private extension TermAndCondition {
    enum SheetState: Identifiable {
        var id: Self { self }
        
        var title: String {
            switch self {
            case .termsOfUse:
                "서비스 이용약관"
            case .privacyPolicy:
                "개인정보 처리방침"
            }
        }
        
        case termsOfUse
        case privacyPolicy
        
        func text(from service: any SettingServiceProtocol) -> String {
            switch self {
            case .termsOfUse:
                service.termsOfUse()
            case .privacyPolicy:
                service.privacyPolicy()
            }
        }
    }
}

#Preview {
    TermAndCondition()
}
