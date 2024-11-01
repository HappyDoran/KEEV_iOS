//
//  Toast.swift
//  KEEV
//
//  Created by 김준성 on 11/1/24.
//

import SwiftUI

/// ToastView에 들어갈 내용을 정의하는 구조체
///
/// - Note: 이 구조체는 `KEEVButtonConfiguration`을 채택하고 있지만, `action`으로 아무 것도 수행하지 않습니다.
/// - Author: newJunsung
struct Toast: KEEVButtonConfiguration {
    /// ToastView에 들어갈 내용
    let title: String
    
    /// ToastView에 좌측에 표시되는 이미지이며, 기본값은 nil입니다.
    let image: Image?
    
    let mainColor: Color
    let subColor: Color?
    
    /// Toast의 액션은 아무 동작도 수행하지 않습니다.
    let action: @MainActor () -> Void = {}
    
    init(title: String, image: Image? = nil, mainColor: Color, subColor: Color) {
        self.title = title
        self.image = image
        self.mainColor = mainColor
        self.subColor = subColor
    }
}

fileprivate struct ToastView: View {
    let toast: Toast
    
    var body: some View {
        contentView
            .padding(.horizontal, 8)
            .background {
                Capsule()
                    .foregroundStyle(toast.mainColor)
            }
            .frame(height: 56)
    }
    
    private var contentView: some View {
        HStack(spacing: 0) {
            if let image = toast.image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            } else {
                CircleCheckIcon(checkColor: toast.mainColor)
                    .frame(width: 40, height: 40)
            }
            
            Text(toast.title)
                .figmaFont(
                    PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium))
                )
                .lineLimit(1)
                .foregroundStyle(toast.subColor ?? .white)
                .padding(.horizontal, 8)
        }
    }
}

extension Toast {
    /// 만든 Toast를 뷰에 보여주는 Modifier
    ///
    /// `toast`가 보여지고 나서 지정한 `duration`이 지나거나 뷰를 탭하면, 뷰가 사라집니다.
    /// 이때, `toast`도 함께 `nil`이 됩니다.
    ///
    /// - Warning: 해당 수정자를 사용하게 되면 뷰 프레임의 최대 높이와 최대 너비 모두 `.infinity`가 됩니다.
    ///
    /// - Author: newJunsung
    struct Modifier: ViewModifier {
        @Binding var toast: Toast?
        @State private var task: Task<Void, Error>? = nil
        let duration: TimeUnit
        
        private var isPresented: Bool { toast != nil }
        
        func body(content: Content) -> some View {
            ZStack(alignment: .bottom) {
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onChange(of: isPresented, startToast)
                
                if let unwrappedToast = toast {
                    ToastView(toast: unwrappedToast)
                        .onTapGesture(perform: finishToast)
                        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.spring, value: isPresented)
        }
        
        private func startToast() {
            if isPresented {
                task = Task.detached {
                    try await Task.sleep(for: .seconds(duration.toSeconds))
                    await finishToast()
                }
            }
        }
        
        private func finishToast() {
            task?.cancel()
            task = nil
            toast = nil
        }
    }
}

#Preview {
    @Previewable @State var toast: Toast? = nil
    
    VStack {
        Button("Start Toast!!!") {
            toast = Toast(title: "hi hi yoyoyo", mainColor: .green500, subColor: .white)
        }
    }
    .modifier(Toast.Modifier(toast: $toast, duration: .seconds(of: 2)))
}
