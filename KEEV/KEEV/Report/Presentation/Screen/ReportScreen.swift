//
//  ReportScreen.swift
//  KEEV
//
//  Created by Yune Cho on 11/8/24.
//

import SwiftUI

/// 신고하기 화면
///
/// 신고하기 화면이며 네비게이션으로 화면이 전환되어야합니다.
///
/// 사용방법은 아래와 같습니다.
///
/// ```swift
/// NavigationStack {
///     NavigationLink {
///         ReportScreen(reportType: .vibe)
///     } label: {
///         Text("신고하기")
///     }
/// }
/// .tint(.gray100)
/// ```
///
/// - Note: 신고하기를 사용하는 뷰 위치에 따라 reportType을 event, vibe, user, comment 중에서 고르면 됩니다.
/// - Author: 라움
struct ReportScreen: View {
    @Injected private var service: any ReportServiceProtocol
    
    private let reportType: ReportType
    
    init(reportType: ReportType) {
        self.reportType = reportType
    }
    
    @State private var selectedCase = ""
    @State private var showReportDoneAlert = false
    @State private var buttonDisabled = true
    @State private var errorForAlert: Error? = nil
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            ReportListView(reportType: reportType, selectedCase: $selectedCase)
                .padding(.top, 16)
                .padding(.horizontal, 16)
            
            Spacer()
            
            CommonButton(
                title: "작성완료",
                action: sendReport,
                style: .maxWidth,
                disabled: buttonDisabled
            )
            .onChange(of: selectedCase, {
                checkButtonDisabled()
            })
            .padding(.top, 12)
            .padding(.horizontal, 16)
            .padding(.bottom, 42)
        }
        .toolbar {            
            ToolbarItem(placement: .principal) {
                Text("신고하기")
                    .figmaFont(PretendardFont.title(style: .xs))
                    .foregroundStyle(.gray100)
            }
        }
        .toolbarRole(.editor)
        .toolbarBackground(
            .grayBG950,
            for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .ignoresSafeArea(edges: .bottom)
        .backgroundForKEEV()
        .customAlert(
            isPresented: $showReportDoneAlert,
            title: "신고가 접수되었습니다.",
            firstButtonText: "확인",
            firstButtonStyle: .active,
            firstButtonAction: {
                dismiss()
            }
        )
        .alertForError($errorForAlert)
    }
}

extension ReportScreen {
    private func checkButtonDisabled() {
        if selectedCase.isEmpty || selectedCase == "기타" {
            buttonDisabled = true
        } else {
            buttonDisabled = false
        }
    }
    
    private func sendReport() {
        guard !selectedCase.isEmpty else { return }
        Task {
            do {
                switch reportType {
                case .reply(let vibeID, let replyID):
                    _ = try await service.sendReplyReport(vibeID: vibeID, replyID: replyID, reason: selectedCase)
                case .event(eventID: let eventID):
                    _ = try await service.sendEventReport(eventID: eventID, reason: selectedCase)
                case .vibe(eventID: let eventID, vibeID: let vibeID):
                    _ = try await service.sendVibeReport(eventID: eventID, vibeID: vibeID, reason: selectedCase)
                case .user(userID: let userID):
                    _ = try await service.sendUserReport(userID: userID, reason: selectedCase)
                }
                showReportDoneAlert = true
            } catch {
                errorForAlert = error
            }
        }
    }
}

#Preview {
    ReportScreen(reportType: .event(eventID: 2827))
}
