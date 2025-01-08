//
//  ReportListView.swift
//  KEEV
//
//  Created by Yune Cho on 11/8/24.
//

import SwiftUI

/// 신고 화면에 나타나는 신고 내용들의 리스트를 보여주는 뷰
///
/// 신고 화면에 나타나는 신고 내용들의 리스트를 보여주는 뷰입니다.
///
/// - Author: 라움
struct ReportListView: View {
    private let reportType: ReportType
    @Binding var selectedCase: String
    
    init(reportType: ReportType, selectedCase: Binding<String>) {
        self.reportType = reportType
        self._selectedCase = selectedCase
    }
    
    @State private var typedReport = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(reportType)")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .semibold)))
                .foregroundStyle(.gray500)
                .padding(.bottom, 12)
            
            ForEach(reportType.reportList, id: \.self) { title in
                ReportListCell(title: title, selectedCase: $selectedCase)
                
                Divider()
            }
            
            ReportListCell(title: "기타", selectedCase: $selectedCase)
            
            if selectedCase.hasPrefix("기타") {
                MultiLineTextField(placeholder: reportType.etcReportPlaceholder, text: $typedReport)
                    .submitLabel(.done)
                    .onSubmit {
                        setETCReportCase()
                    }
                    .padding(.bottom, 16)
                    .transition(.scale)
            }
            
            Divider()
                .transition(.slide)
        }
        .animation(.bouncy, value: selectedCase)
    }
}

extension ReportListView {
    private func setETCReportCase() {
        if typedReport.isEmpty {
            selectedCase = "기타"
        } else {
            selectedCase = "기타: \(typedReport)"
        }
    }
}

#Preview {
    ReportListView(reportType: .event(eventID: "dee"), selectedCase: .constant(""))
}
