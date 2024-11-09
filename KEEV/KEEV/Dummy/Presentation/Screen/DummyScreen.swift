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
        NavigationStack {
            VStack(spacing: 0){
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
                
                ZStack {
                    Color.gray950
                    
                    VStack(spacing: 0){
                        HStack{
                            ForEach((TabbedItem.allCases), id: \.self){ item in
                                Button{
                                    selectedItem = item.rawValue
                                } label: {
                                    CustomTabItem(tabbItem: item, isActive: (selectedItem == item.rawValue))
                                }
                            }
                        }
                        Spacer()
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 83)
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
}

extension DummyScreen{
    func CustomTabItem(tabbItem: TabbedItem, isActive: Bool) -> some View{
        HStack(spacing: 10){
            Spacer()
            VStack(alignment: .center, spacing : 0){
                Image(systemName: tabbItem.iconName)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isActive ? .brand500 : .gray500)
                    .frame(height: 21)
                    .padding(.top, 13)
                
                Text(tabbItem.title)
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
