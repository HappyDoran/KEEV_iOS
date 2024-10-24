//
//  CheckBox.swift
//  KEEV
//
//  Created by 김준성 on 10/24/24.
//

import SwiftUI

// MARK: CircleCheckBox
struct CircleCheckBox: View {
    @Binding private var isChecked: Bool
    
    init(isChecked: Binding<Bool>) {
        self._isChecked = isChecked
    }
    
    var body: some View {
        GeometryReader { proxy in
            let frame = proxy.frame(in: .local)
            
            ZStack {
                UncheckedCircleView(frame: frame)
                    .position(x: frame.midX, y: frame.midY)
                if isChecked {
                    CheckedCircleView(frame: frame)
                }
            }
        }
    }
}

// MARK: CheckedCircleView
fileprivate struct CheckedCircleView: View {
    private let frame: CGRect
    
    init(frame: CGRect) {
        self.frame = frame
    }
    
    private var width: CGFloat {
        min(frame.width, frame.height)
    }
    
    private var radius: CGFloat {
        width - 12 / 32 * width
    }
    
    private var startPoint: CGPoint {
        CGPoint(
            x: frame.midX - 5 / 20 * radius,
            y: frame.midY - 2 / 20 * radius
        )
    }
    
    private var middlePoint: CGPoint {
        let center = CGPoint(x: frame.midX, y: frame.midY)
        
        return CGPoint(
            x: center.x,
            y: center.y + 3 / 20 * radius
        )
    }
    
    private var endPoint: CGPoint {
        CGPoint(
            x: frame.midX + 5 / 20 * radius,
            y: frame.midY - 2 / 20 * radius
        )
    }
    
    var body: some View {
        Path { path in
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

// MARK: UncheckedCircleView
fileprivate struct UncheckedCircleView: View {
    private let frame: CGRect
    
    init(frame: CGRect) {
        self.frame = frame
    }
    
    private var width: CGFloat {
        min(frame.width, frame.height)
    }
    
    private var radius: CGFloat {
        width - 12 / 32 * width
    }
    
    private var padding: CGFloat {
        6 / 32 * width
    }
    
    private var lineWidth: CGFloat {
        2 / 20 * radius
    }
    
    var body: some View {
        Circle()
            .stroke(Color.gray, style: StrokeStyle(lineWidth: lineWidth))
            .padding(padding + lineWidth / 2)
    }
}

#Preview {
    @Previewable @State var isChecked = false
    
    CircleCheckBox(isChecked: $isChecked)
        .frame(width: 32, height: 32)
        .onTapGesture {
            isChecked.toggle()
        }
}
