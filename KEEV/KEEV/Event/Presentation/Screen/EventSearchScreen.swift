//
//  EventSearchScreen.swift
//  KEEV
//
//  Created by Doran on 11/2/24.
//

import SwiftUI

struct EventSearchScreen: View {
    @Binding private var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    var body: some View {
        VStack(spacing: 0){
            SearchHeader(isPresented: $isPresented)
        }
        .backgroundForKEEV()
    }
}

#Preview {
    EventSearchScreen(isPresented: .constant(false))
        .backgroundForKEEV()
}
