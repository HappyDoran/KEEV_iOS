//
//  DDayBox.swift
//  KEEV
//
//  Created by Yune Cho on 10/27/24.
//

import SwiftUI

/// 공연 D-Day를 표시하는 박스
///
/// 공연 날짜를 인자로 받아서 해당 공연의 D-Day를 표시해줍니다.
///
/// - Author: 라움
struct DDayBox: View {
    private let date: Date
    private let dateFormatter = DateFormatter()
    private let calendar = Calendar.current
    private let currentDate = Date()
    @State private var dateCount = 0
    
    init(date: Date) {
        self.date = date
    }
    
    // 공연 날짜와 현재 날짜의 날짜 차이를 계산하는 함수
    // dateCount 값이 음수가 되면 아직 공연일이 되지 않은 공연입니다.
    // dateCount 값이 0이면 오늘이 공연 당일입니다.
    // dateCount 값이 양수가 되면 이미 공연일이 지난 공연입니다.
    private func calculateDate() {
        dateFormatter.dateFormat = "yyyy.MM.dd"
        if let count = calendar.dateComponents([.day], from: date, to: currentDate).day {
            dateCount = count
        }
    }
    
    // dateCount에 따라 뷰를 빌드해주는 함수입니다.
    @ViewBuilder
    private func dDayBox() -> some View {
        if dateCount < 0 {
            Text("D\(dateCount)")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .semibold)))
                .foregroundStyle(.gray500)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background() {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(height: 19)
                        .foregroundStyle(.gray800)
                }
        } else if dateCount == 0 {
            Text("D-DAY")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .semibold)))
                .foregroundStyle(.brand400)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(height: 19)
                        .foregroundStyle(.brand400)
                        .opacity(0.2)
                }
        } else {
            Text("D+\(dateCount)")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .semibold)))
                .foregroundStyle(.gray600)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .overlay {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(height: 19)
                        .foregroundStyle(.clear)
                        .overlay {
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.gray800, lineWidth: 1.5)
                        }
                }
        }
    }
    
    var body: some View {
        dDayBox()
            .onAppear {
                calculateDate()
            }
    }
}

#Preview {
    @Previewable let before = "2024.12.31"
    @Previewable let today = Date()
    @Previewable let after = "2024.03.04"
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
    
    DDayBox(date: dateFormatter.date(from: before)!)
    DDayBox(date: today)
    DDayBox(date: dateFormatter.date(from: after)!)
}
