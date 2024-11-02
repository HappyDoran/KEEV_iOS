//
//  EventSearchScreen.swift
//  KEEV
//
//  Created by Doran on 11/2/24.
//

import SwiftUI

struct EventSearchScreen: View {
    @State private var searchText: String = ""
    @Binding private var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    var body: some View {
        VStack(spacing: 0){
            SearchHeader(isPresented: $isPresented)
            SearchField(text: $searchText)
            Spacer()
        }
        .backgroundForKEEV()
    }
}


#Preview {
    EventSearchScreen(isPresented: .constant(false))
        .backgroundForKEEV()
}
