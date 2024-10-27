//
//  Check.swift
//  KEEV
//
//  Created by Doran on 10/28/24.
//

import SwiftUI

struct Check: View {
    private var checkColor: Color
    
    init(checkColor: Color) {
        self.checkColor = checkColor
    }
    
    var body: some View {
        GeometryReader { proxy in
            let frame = proxy.frame(in: .local)
            
            CheckCircleView(frame: frame, checkColor: checkColor).position(x: frame.midX, y: frame.midY)
            
        }
    }
}

fileprivate struct CheckCircleView: View {
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
        Color.brand500
        Path { path in
            path.move(to: startPoint)
            path.addLine(to: middlePoint)
            path.addLine(to: endPoint)
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
    Check(checkColor: .brand500)
}
