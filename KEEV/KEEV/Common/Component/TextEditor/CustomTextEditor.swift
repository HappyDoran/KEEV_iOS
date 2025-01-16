//
//  CustomTextEditor.swift
//  KEEV
//
//  Created by Doran on 1/8/25.
//

import SwiftUI

/// Text 작성시 줄바꿈에 따라 유동적으로 늘어나는 height를 가진 TextEditor
///
/// - Parameters:
///   - height: 초기 height 값
///   - text: 텍스트
///   - customFont: 행간을 고려하여 height를 늘려야하기 때문에 필요한 폰트
///   - textColor: 텍스트 색상
///   - scrollPossibleHeight: 일정 크기만큼 늘어날 경우에 스크롤이 가능하게 끔 하는 height
///
/// - Author: Doran
struct CustomTextEditor: UIViewRepresentable {
    typealias UIViewType = UITextView
    
    @Binding var height: CGFloat
    @Binding var text: String
    private let customFont: UIFont
    private let textColor: UIColor
    private let scrollPossibleHeight: CGFloat
    
    init(_ height: Binding<CGFloat>,
         _ text: Binding<String>,
         textColor: UIColor,
         customFont: UIFont,
         scrollPossibleHeight: CGFloat) {
        self._height = height
        self._text = text
        self.textColor = textColor
        self.customFont = customFont
        self.scrollPossibleHeight = scrollPossibleHeight
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextEditor>) -> UITextView {
        let view = UITextView()
        
        view.font = customFont
        view.backgroundColor = .clear
        view.textColor = textColor
        view.text = text
        view.delegate = context.coordinator
        
        view.showsVerticalScrollIndicator = false
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.isScrollEnabled = true
        
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<CustomTextEditor>) {
        uiView.text = text
        uiView.textColor = textColor
        uiView.isScrollEnabled = true
        
        DispatchQueue.main.async {
            let calculatedHeight = uiView.contentSize.height
            
            if calculatedHeight > scrollPossibleHeight {
                height = scrollPossibleHeight
            } else {
                height = calculatedHeight
            }
        }
    }
}

extension CustomTextEditor {
    class Coordinator: NSObject, UITextViewDelegate {
        
        var parent: CustomTextEditor
        
        init(_ parent: CustomTextEditor) { self.parent = parent }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == parent.textColor {
                textView.textColor = parent.textColor
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let calculatedHeight = textView.contentSize.height
                                
                if calculatedHeight > parent.scrollPossibleHeight {
                    self.parent.height = parent.scrollPossibleHeight
                } else {
                    self.parent.height = calculatedHeight
                }
                
                self.parent.text = textView.text
            }
        }
    }
}
