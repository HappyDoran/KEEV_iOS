//
//  KEEVActionSheet.swift
//  KEEV
//
//  Created by 김준성 on 10/31/24.
//

import SwiftUI

/// KEEV에서 사용되는 액션시트
///
/// `KEEVActionSheet`의 파라미터인 `configurations`는 `KEEVButtonConfiguration`을 채택한 타입의 배열을 넣을 수 있습니다.
/// `KEEVButtonConfiguration`은 `KEEVActionSheet.ButtonConfiguration`을 채택했기 때문에 넣을 수 있습니다.
///
/// - Parameters:
///     - `isPresented`: 액션 시트를 보여줄 지 결정하는 뷰.
///     - `configurations`: 어떤 내용물들을 보여줄 지 결정하는 버튼에 대한 설정.
///
/// - Author: newJunsung
struct KEEVActionSheet: View {
    @Binding var isPresented: Bool
    let configurations: [any KEEVButtonConfiguration]
    
    init(isPresented: Binding<Bool>, configurations: [any KEEVButtonConfiguration]) {
        self._isPresented = isPresented
        self.configurations = configurations
    }
    
    init(isPresented: Binding<Bool>, defaults: [Self.ButtonConfiguration]) {
        self._isPresented = isPresented
        self.configurations = defaults
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            VStack(spacing: 0) {
                ForEach(Array(configurations.enumerated()), id: \.element.id) { index, configuration in
                    if index == 0 && index == configurations.count - 1 {
                        SelectionButton(configuration: configuration, isFirst: true, isLast: true)
                    } else if index == 0 {
                        SelectionButton(configuration: configuration, isFirst: true, isLast: false)
                    } else if index == configurations.count - 1 {
                        SelectionButton(configuration: configuration, isFirst: false, isLast: true)
                    } else {
                        SelectionButton(configuration: configuration, isFirst: false, isLast: false)
                    }
                }
            }
            
            CloseButton(isPresented: $isPresented)
        }
    }
}

extension KEEVActionSheet {
    /// 액션 시트 닫기 버튼
    ///
    /// 앱션 시트 최하단에 노출되는 액션 시트 닫기 버튼입니다.
    ///
    /// - Author: 라움
    private struct CloseButton: View {
        @Binding var isPresented: Bool
        
        var body: some View {
            Button {
                isPresented = false
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 56)
                    .foregroundStyle(.gray800)
                    .overlay {
                        Text("닫기")
                            .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .semibold)))
                            .foregroundStyle(.gray100)
                    }
            }
        }
    }
}

#Preview {
    @Previewable @State var isPresented = false
    
    VStack {
        Button("hihi") {
            isPresented = true
        }
    }
    .actionSheetForKEEV(
        isPresented: $isPresented,
        defaults: .myComment(modifyHandler: {}, deleteHandler: {})
    )
}
