//
//  CheckBox.swift
//  KEEV
//
//  Created by 김준성 on 10/24/24.
//

import SwiftUI

// MARK: CircleCheckBox

/// 원형 체크 박스
///
/// 원 형태인 체크박스를 만듭니다.
/// 해당 뷰는 이미지를 쓰는 것이 아닌, 직접 뷰를 그립니다.
/// `isChecked`라는 `Bool` 값이 속성으로 있기에, 참/거짓 여부에 따라 뷰가 변경됩니다.
///
/// - Note: 내부는 `GeometryReader`와 `ZStack`으로 구성되어 있습니다.
/// 체크안된 상태의 원은 계속 있지만, 체크된 상태의 원은 `isChecked`의 값이 참이면 기존 원에 덮어씌워 올라갑니다.
/// - Author: newJunsung
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
        .stroke(Color.gray800, style: StrokeStyle(lineWidth: 2 / 20 * radius, lineCap: .round, lineJoin: .round))
        .background(
            Circle()
                .frame(width: radius, height: radius)
                .foregroundStyle(.brand500)
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
            .stroke(Color.gray800, style: StrokeStyle(lineWidth: lineWidth))
            .padding(padding + lineWidth / 2)
    }
}

#Preview {
    @Previewable @State var isChecked = false
    
    CircleCheckBox(isChecked: $isChecked)
        .onTapGesture {
            isChecked.toggle()
        }
}
