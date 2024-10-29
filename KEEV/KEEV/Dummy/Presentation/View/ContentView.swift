//
//  ContentView.swift
//  KEEV
//
//  Created by 김준성 on 10/15/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var tokenService = TokenService()
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("액세스 토큰 입력", text: $tokenService.accessToken)
            
            TextField("리프레시 토큰 입력", text: $tokenService.refreshToken)
            
            Button(action: {
                tokenService.save()
            }){
                Text("토큰 저장")
            }
            
            Button(action: {
                tokenService.load()
            }){
                Text("토큰 불러오기")
            }
            
            Button(action: {
                tokenService.delete()
            }){
                Text("토큰 삭제")
            }
            
            Text("액세스 토큰:")
            Text(tokenService.retrievedAccessToken)
            Text("리프레시 토큰:")
            Text(tokenService.retrievedRefreshToken)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
