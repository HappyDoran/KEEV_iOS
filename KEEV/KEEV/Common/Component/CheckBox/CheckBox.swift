//
//  CheckBox.swift
//  KEEV
//
//  Created by 김준성 on 10/24/24.
//

import SwiftUI

struct CheckBox: View {
    var body: some View {
        CheckedCircleView()
            .frame(width: 32, height: 32)
    }
}

fileprivate struct CheckedCircleView: View {
    var body: some View {
        GeometryReader { proxy in
            let frame = proxy.frame(in: .local)
            let width = min(frame.width, frame.height)
            let radius = width - 12 / 32 * width
            
            Path { path in
                let startPoint = getStartPoint(from: frame, with: radius)
                let middlePoint = getMiddlePoint(from: frame, with: radius)
                let endPoint = getEndPoint(from: frame, with: radius)
                let _ = print(startPoint, middlePoint, endPoint)
                
                
                path.move(to: startPoint)
                path.addLine(to: middlePoint)
                path.addLine(to: endPoint)
            }
            .stroke(style: StrokeStyle(lineWidth: 2 / 20 * radius, lineCap: .round, lineJoin: .round))
            .foregroundStyle(.black)
            .background(
                Circle()
                    .frame(width: radius, height: radius)
                    .foregroundStyle(.purple)
            )
        }
    }
    
    private func getStartPoint(from frame: CGRect, with radius: CGFloat) -> CGPoint {
        CGPoint(
            x: frame.midX - 5 / 20 * radius,
            y: frame.midY - 2 / 20 * radius
        )
    }
    
    private func getMiddlePoint(from frame: CGRect, with radius: CGFloat) -> CGPoint {
        let center = CGPoint(x: frame.midX, y: frame.midY)
        
        return CGPoint(
            x: center.x,
            y: center.y + 3 / 20 * radius
        )
    }
    
    private func getEndPoint(from frame: CGRect, with radius: CGFloat) -> CGPoint {
        CGPoint(
            x: frame.midX + 5 / 20 * radius,
            y: frame.midY - 2 / 20 * radius
        )
    }
}

#Preview {
    CheckBox()
}
