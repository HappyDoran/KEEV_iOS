//
//  DummyScreen.swift
//  KEEV
//
//  Created by Doran on 10/16/24.
//

import SwiftUI

struct DummyScreen: View {
    @State private var isPresented = false
    @State private var selectedItem = "info"
    @State private var oldSelectedItem = "info"
    
    var body: some View {
        VStack(spacing: 0){
            ZStack(alignment: .bottom){
                TabView(selection: $selectedItem) {
                    Group {
                        EventInfoScreen()
                            .tag(TabbedItem.info.rawValue)
                        
                        EmptyView()
                            .tag(TabbedItem.write.rawValue)
                        
                        DummyView()
                            .tag(TabbedItem.profile.rawValue)
                    }
                    .toolbar(.hidden, for: .tabBar)
                }
                .onChange(of: selectedItem) { _, newValue in
                    if newValue == TabbedItem.write.rawValue {
                        isPresented = true
                        selectedItem = oldSelectedItem
                    } else {
                        oldSelectedItem = newValue
                    }
                }
                .sheet(isPresented: $isPresented) {
                    ContentView()
                }
            }
            ZStack {
                VStack(spacing: 0){
                    HStack{
                        ForEach((TabbedItem.allCases), id: \.self){ item in
                            Button{
                                selectedItem = item.rawValue
                            } label: {
                                CustomTabItem(imageName: item.iconName, title: item.title, isActive: (selectedItem == item.rawValue))
                            }
                        }
                    }
                    Spacer()
                }
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 83)
            .background(.gray950)
            .overlay(
                Rectangle()
                    .fill(.gray800)
                    .frame(height: 2)
                    , alignment: .top
            )
        }
        .ignoresSafeArea(.all)
    }
}

extension DummyScreen{
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View{
        HStack(spacing: 10){
            Spacer()
            VStack(alignment: .center, spacing : 0){
                Image(systemName: imageName)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isActive ? .brand500 : .gray500)
                    .frame(height: 21)
                    .padding(.top, 13)
                
                Text(title)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall4, bodyWeight: .regular)))
                    .foregroundColor(isActive ? .brand500 : .gray500)
                    .padding(.top , 6)
            }
            Spacer()
        }
    }
}

#Preview {
    DummyScreen()
}
