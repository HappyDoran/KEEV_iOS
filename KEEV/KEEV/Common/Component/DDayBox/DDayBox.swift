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
    private let difference: Int?
    
    init(difference: Int?) {
        self.difference = difference
    }
    
    init(date: Date) {
        self.difference = date.difference(from: .now)
    }
    
    var body: some View {
        if let difference = difference {
            if difference < 0 {
                Text("D\(difference)")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .semibold)))
                    .foregroundStyle(.gray500)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background() {
                        RoundedRectangle(cornerRadius: 4)
                            .frame(height: 19)
                            .foregroundStyle(.gray800)
                    }
            } else if difference == 0 {
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
                Text("D+\(difference)")
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
                                    .inset(by: 1)
                                    .stroke(Color.gray800, lineWidth: 1.5)
                            }
                    }
            }
        }
    }
}

#Preview {
    @Previewable let before = "2024.12.13"
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
