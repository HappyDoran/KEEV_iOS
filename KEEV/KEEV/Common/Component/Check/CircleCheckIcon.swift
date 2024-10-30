//
//  CircleCheckIcon.swift
//  KEEV
//
//  Created by Doran on 10/28/24.
//

import SwiftUI

/// 프로필 수정을 완료했을 때 나오는 토스트 메시지의 아이콘
///
/// - Parameters:
///   - checkColor: 체크 표시의 색상
///
///  디자이너의 의도대로라면 체크 아이콘이 뚫려있어서 뒤의 배경색이 보이는 느낌이라 checkColor를 파라미터로 받아서 적용하여 마치 뚫려보이는 것처럼 합니다.
///
///
/// - Author: Doran
struct CircleCheckIcon: View {
    private var checkColor: Color
    
    init(checkColor: Color) {
        self.checkColor = checkColor
    }
    
    var body: some View {
        GeometryReader { proxy in
            let frame = proxy.frame(in: .local)
            
            ReverseCheckCircleView(frame: frame, checkColor: checkColor).position(x: frame.midX, y: frame.midY)
            
        }
    }
}

fileprivate struct ReverseCheckCircleView: View {
    let frame: CGRect
    let checkColor: Color
    
    private var width: CGFloat {
        min(frame.width, frame.height)
    }
    
    private var radius: CGFloat {
        width - 12 / 32 * width
    }
    
    private var startPoint: CGPoint {
        CGPoint(
            x: frame.midX - 5 / 20 * radius,
            y: frame.midY - 1 / 20 * radius
        )
    }
    
    private var middlePoint: CGPoint {
        let center = CGPoint(x: frame.midX, y: frame.midY)
        
        return CGPoint(
            x: center.x - 1 / 20 * radius,
            y: center.y + 3 / 20 * radius
        )
    }
    
    private var endPoint: CGPoint {
        CGPoint(
            x: frame.midX + 5 / 20 * radius,
            y: frame.midY - 3 / 20 * radius
        )
    }
    
    var body: some View {
        Path { path in
            path.checkMark(startPoint: startPoint, middlePoint: middlePoint, endPoint: endPoint)
        }
        .stroke(checkColor, style: StrokeStyle(lineWidth: 2 / 20 * radius, lineCap: .round, lineJoin: .round))
        .background(
            Circle()
                .frame(width: radius, height: radius)
                .foregroundStyle(.gray50)
        )
    }
}

#Preview {
    CircleCheckIcon(checkColor: .brand500)
}
