//
//  EventVibeActionSheet.swift
//  KEEV
//
//  Created by Doran on 11/24/24.
//

import SwiftUI

extension EventVibeActionSheet {
    /// 액션 시트에서 사용되는 타입을 나열한 열거형
    ///
    /// 최신순인지, 좋아요순인지를 판별할 때 사용합니다.
    ///
    /// - Author: Doran
    private enum ActionType {
        case latest
        case liked
    }
}

/// Event Vibe에서 보여지는 액션시트
///
/// - Parameters:
///     - `isPresented`: 액션 시트를 보여줄 지 결정하는 뷰.
///
/// - Author: Doran
struct EventVibeActionSheet: View {
    @Binding private var isPresented: Bool
    @State private var selectedAction: ActionType? = .latest
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 0) {
                ActionButton(isPresented: $isPresented, title: "최신순", actionType: .latest, selectedAction: $selectedAction, isFirst: true, isLast: false)
                ActionButton(isPresented: $isPresented, title: "좋아요순", actionType: .liked, selectedAction: $selectedAction, isFirst: false, isLast: true)
            }
            CloseButton(isPresented: $isPresented)
        }
    }
}

extension EventVibeActionSheet {
    /// 액션 시트에 들어가는 버튼
    ///
    /// - Parameters:
    ///     - `isPresented`: 액션 시트를 보여줄 지 결정하는 뷰.
    ///     - `title`: 버튼 텍스트
    ///     - `actionType`: 버튼의 타입 (최신순인지, 좋아요순인지)
    ///     - `selectedAction`: 선택한 버튼의 타입
    ///     - `isFirst`: 버튼이 맨 위의 버튼인지
    ///     - `isLast`: 버튼이 맨 아래의 버튼인지
    ///
    ///
    /// - Author: Doran
    private struct ActionButton: View {
        @Binding var isPresented: Bool
        @Binding var selectedAction: EventVibeActionSheet.ActionType?
        private let title: String
        private let actionType: EventVibeActionSheet.ActionType
        private let isFirst: Bool
        private let isLast: Bool
        
        init(isPresented: Binding<Bool>, title: String, actionType: EventVibeActionSheet.ActionType, selectedAction: Binding<EventVibeActionSheet.ActionType?>, isFirst: Bool, isLast: Bool) {
            self._isPresented = isPresented
            self.title = title
            self.actionType = actionType
            self._selectedAction = selectedAction
            self.isFirst = isFirst
            self.isLast = isLast
        }
        
        var body: some View {
            VStack(spacing: 0) {
                Button(action: {
                    selectedAction = actionType
                }) {
                    UnevenRoundedRectangle(
                        topLeadingRadius: isFirst ? 16 : 0,
                        bottomLeadingRadius: isLast ? 16 : 0,
                        bottomTrailingRadius: isLast ? 16 : 0,
                        topTrailingRadius: isFirst ? 16 : 0
                    )
                    .frame(height: 56)
                    .foregroundStyle(.grayBG700)
                    .overlay(alignment: .center) {
                        HStack(spacing: 4){
                            Text(title)
                                .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .medium)))
                                .foregroundStyle(.gray50)
                            if selectedAction == actionType {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.brand500)
                                    .frame(width: 24, height: 24)
                            }
                            else {
                                Text("")
                                    .frame(width: 24, height: 24)
                            }
                        }
                        .padding(.leading, 24)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 16)
                    }
                }
                
                if !isLast {
                    Divider()
                        .frame(height: 1)
                        .background(.gray700)
                }
            }
        }
    }
    
    /// 액션 시트 닫기 버튼
    ///
    /// 앱션 시트 최하단에 노출되는 액션 시트 닫기 버튼입니다.
    ///
    /// - Author: Doran
    private struct CloseButton: View {
        @Binding var isPresented: Bool
        
        var body: some View {
            Button {
                isPresented = false
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 56)
                    .foregroundStyle(.grayBG700)
                    .overlay {
                        Text("닫기")
                            .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .semibold)))
                            .foregroundStyle(.gray100)
                    }
            }
        }
    }
}

extension EventVibeActionSheet {
    struct Modifier: ViewModifier {
        
        @Binding var isPresented: Bool
        
        init(isPresented: Binding<Bool>) {
            self._isPresented = isPresented
        }
        
        /// Modifier가 적용된 새로운 뷰를 리턴하는 함수
        ///
        /// - Parameters:
        ///   - content: 기존 뷰
        ///
        /// - Returns: EventVibe ActionSheet 뷰
        ///
        /// - Author: Doran
        func body(content: Content) -> some View {
            ZStack {
                content
                
                if isPresented {
                    Color.black
                        .opacity(0.7)
                        .ignoresSafeArea(.all)

                    VStack {
                        Spacer()
                        EventVibeActionSheet(isPresented: $isPresented)
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                            .padding(.bottom, 44)
                            .background {
                                UnevenRoundedRectangle(
                                    topLeadingRadius: 24,
                                    bottomLeadingRadius: 0,
                                    bottomTrailingRadius: 0,
                                    topTrailingRadius: 24
                                )
                                .foregroundStyle(.grayBG900)
                            }
                    }
                    .transition(.move(edge: .bottom))
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .animation(.snappy, value: isPresented)
            .onTapGesture {
                isPresented = false
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
    .actionSheetForEventVibe(isPresented: $isPresented)
}
