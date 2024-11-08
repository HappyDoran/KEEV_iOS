//
//  ReportScreen.swift
//  KEEV
//
//  Created by Yune Cho on 11/8/24.
//

import SwiftUI

struct ReportScreen: View {
    private let reportType: ReportType
    
    init(reportType: ReportType) {
        self.reportType = reportType
    }
    
    private let reportService = ReportService()
    @State private var selectedCase = ""
    @State private var showReportDoneAlert = false
    @State private var buttonDisabled = true
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            ReportListView(reportType: reportType, selectedCase: $selectedCase)
                .padding(.top, 16)
                .padding(.horizontal, 16)
            
            Spacer()
            
            CommonButton(
                title: "작성완료",
                action: {
                    reportService.sendReport(selectedCase)
                    
                    showReportDoneAlert = true
                },
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
}

#Preview {
    ReportScreen(reportType: .event)
}
