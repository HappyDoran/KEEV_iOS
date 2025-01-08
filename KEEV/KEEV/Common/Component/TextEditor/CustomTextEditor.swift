//
//  CustomTextEditor.swift
//  KEEV
//
//  Created by Doran on 1/8/25.
//

import SwiftUI

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
