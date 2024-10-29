//
//  ContentView.swift
//  KEEV
//
//  Created by 김준성 on 10/15/24.
//

import SwiftUI

struct ContentView: View {
    @State private var inputText = ""
    @State private var retrievedText = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("저장할 텍스트", text: $inputText)
            
            Button(action: {
                guard let data = inputText.data(using: .utf8) else { return }
                let success = KeyChainUtility.shared.create(data)
                if success {
                    print("Data saved successfully.")
                } else {
                    print("Failed to save data.")
                }
            }){
                Text("키체인 저장")
            }
            
            Button(action: {
                if let data = KeyChainUtility.shared.read(),
                   let text = String(data: data, encoding: .utf8) {
                    retrievedText = text
                } else {
                    retrievedText = "No data found."
                }
            }){
                Text("키체인 불러오기")
            }
            
            Button(action: {}){
                Text("키체인 삭제")
            }
            
            Text("복호화된 데이터")
            Text(retrievedText)
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
