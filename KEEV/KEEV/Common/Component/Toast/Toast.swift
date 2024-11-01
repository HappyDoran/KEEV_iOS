//
//  Toast.swift
//  KEEV
//
//  Created by 김준성 on 11/1/24.
//

import SwiftUI

struct Toast: View {
    let content = "프로필이 변경되었습니다."
    
    var body: some View {
        contentView
            .padding(.horizontal, 8)
            .background {
                Capsule()
                    .foregroundStyle(.green500)
            }
            .frame(height: 56)
    }
    
    private var contentView: some View {
        HStack(spacing: 0) {
            CircleCheckIcon(checkColor: .green500)
                .frame(width: 32, height: 40)
            
            Text(content)
                .figmaFont(
                    PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium))
                )
                .lineLimit(1)
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
        }
    }
}

extension Toast {
    struct Modifier: ViewModifier {
        @Binding var isPresented: Bool
        @State private var task: Task<Void, Error>? = nil
        let timeout: TimeInterval = 3
        
        func body(content: Content) -> some View {
            ZStack(alignment: .bottom) {
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onChange(of: isPresented, startToast)
                
                if isPresented {
                    Toast()
                        .onTapGesture(perform: finishToast)
                        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.spring, value: isPresented)
        }
        
        private func startToast() {
            if isPresented {
                task = Task.detached {
                    try await Task.sleep(for: .seconds(3))
                    await finishToast()
                }
            }
        }
        
        private func finishToast() {
            task?.cancel()
            task = nil
            isPresented = false
        }
    }
}

#Preview {
    @Previewable @State var isToastPresented: Bool = false
    
    VStack {
        Button("Start Toast!!!") {
            isToastPresented = true
        }
    }
    .modifier(Toast.Modifier(isPresented: $isToastPresented))
}
