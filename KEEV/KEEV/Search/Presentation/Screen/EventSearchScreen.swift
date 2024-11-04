//
//  EventSearchScreen.swift
//  KEEV
//
//  Created by Doran on 11/2/24.
//

import SwiftUI


/// 이벤트 검색에 해당하는 것을 전반적으로 담당하는 스크린
///
/// - Author: Doran
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
            SearchBefore(text: $searchText).padding(.horizontal, 16)
            SearchAfter().padding(.horizontal, 16)
            
            Spacer()
        }
        .backgroundForKEEV()
    }
}


#Preview {
    EventSearchScreen(isPresented: .constant(false))
        .backgroundForKEEV()
}
