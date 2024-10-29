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
            TextField("Enter text", text: $inputText)
            
            Button(action: {}){
                Text("키체인 저장")
            }
            
            Button(action: {}){
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
