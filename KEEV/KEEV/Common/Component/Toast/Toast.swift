//
//  Toast.swift
//  KEEV
//
//  Created by 김준성 on 11/1/24.
//

import SwiftUI

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

struct ToastView: View {
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

extension ToastView {
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
    .modifier(ToastView.Modifier(toast: $toast, duration: .seconds(of: 2)))
}
