//
//  MultiLineTextField.swift
//  KEEV
//
//  Created by Doran on 1/8/25.
//

import SwiftUI

struct MultiLineTextField: View {
    private let placeholder: String
    @Binding var text: String
    private let keyboardType: UIKeyboardType
    private let maxLength: Int?
    @Binding var errorMessage: String
    
    @State private var textHeight: CGFloat = 0
    private let customFont = PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .medium))
    
    @FocusState private var isFocused: Bool
    
    init(placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default, maxLength: Int? = nil, errorMessage: Binding<String> = .constant("")) {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.maxLength = maxLength
        self._errorMessage = errorMessage
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
                .foregroundStyle(isFocused ? (errorMessage.isEmpty ? .gray300 : .red500) : .gray700)
                .frame(height: textHeight + 32)
                .overlay {
                    CustomTextEditor($textHeight, $text, textColor: .gray100, customFont: customFont.uiFont, scrollPossibleHeight: 199)
                        .focused($isFocused)
                        .tint(.brand500)
                        .keyboardType(keyboardType)
                        .frame(height: textHeight)
                        .overlay(alignment: .topLeading) {
                            Text(placeholder)
                                .foregroundStyle(text.isEmpty ? .gray700 : .clear)
                                .figmaFont(customFont)
                                .padding(.top, 7)
                                .padding(.leading, 5)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .medium)))
                    .foregroundStyle(.red500)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
            }
        }
    }
}

extension MultiLineTextField {
    private struct CustomTextEditor: UIViewRepresentable{
        typealias UIViewType = UITextView
        
        @Binding var height: CGFloat
        @Binding var text: String
        private let customFont: UIFont
        
        let textColor: UIColor
        let scrollPossibleHeight:  CGFloat
        
        init(_ height: Binding<CGFloat>,
             _ text: Binding<String>,
             textColor: UIColor,
             customFont: UIFont,
             scrollPossibleHeight:  CGFloat) {
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
            view.becomeFirstResponder()
            
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
    
                print(calculatedHeight)
                
                if calculatedHeight > scrollPossibleHeight {
                    height = scrollPossibleHeight
                } else {
                    height = calculatedHeight
                }
            }
        }
    }
}

extension MultiLineTextField {
    private class Coordinator: NSObject, UITextViewDelegate {
        
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


#Preview {
    @Previewable @State var text = ""
    
    MultiLineTextField(placeholder: "닉네임", text: $text, maxLength: 14)
}
