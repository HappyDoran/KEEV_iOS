//
//  ReportListCell.swift
//  KEEV
//
//  Created by Yune Cho on 11/8/24.
//

import SwiftUI

/// 신고하기 화면의 각 신고 내용에 해당하는 Cell
///
/// 신고하기 화면의 각 신고 내용에 해당하는 Cell입니다.
///
/// - Author: 라움
struct ReportListCell: View {
    private let title: String
    @Binding var selectedCase: String
    
    init(title: String, selectedCase: Binding<String>) {
        self.title = title
        self._selectedCase = selectedCase
    }
    
    @State var isChecked: Bool = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            CircleCheckBox(isChecked: $isChecked)
                .frame(width: 32, height: 32)
                .padding(.trailing, 8)
            
            Text(title)
                .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .medium)))
                .foregroundStyle(isChecked ? .brand500 : .gray100)
            
            Spacer()
        }
        .frame(height: 64)
        .onTapGesture {
            selectReportCase()
        }
        .onChange(of: selectedCase) {
            checkOnlyOneReportCase()
        }
    }
}

extension ReportListCell {
    private func selectReportCase() {
        isChecked.toggle()
        if selectedCase == title {
            selectedCase = ""
        } else {
            selectedCase = title
        }
    }
    
    private func checkOnlyOneReportCase() {
        if selectedCase.hasPrefix(title) {
            isChecked = true
        } else {
            isChecked = false
        }
    }
}

#Preview {
    ReportListCell(title: "일정이 잘못된 공연정보", selectedCase: .constant(""))
}
