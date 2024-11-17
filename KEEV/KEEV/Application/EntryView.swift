//
//  EntryView.swift
//  KEEV
//
//  Created by Doran on 11/9/24.
//

import SwiftUI

/// TabBar가 포함된 뷰(.tabItem이 포함된 경우)
///
/// 탭바의 배경색, 탭바의 구분선을 UITabBarAppearance()를 사용하여 구현
///
/// - Note: 탭바의 아이템과 구분선 사이의 padding, 탭바의 이미자와, 텍스트 사이의 padding을 넣고싶었지만 label쪽 커스텀이 빡세보입니다.
///
/// - Author: Doran
struct EntryView: View {
    @State private var isPresented = false
    @State private var selectedItem = TabbedItem.info.rawValue
    @State private var showActionSheet = false
    @State private var navigateToReport = false
    
    init() {
        let appearance = UITabBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(.gray950)
        appearance.shadowColor = UIColor(.gray500)
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                TabView(selection: $selectedItem) {
                    EventInfoScreen()
                        .tabItem {
                            TabbedItem.label(for: .info)
                        }
                        .tag(TabbedItem.info.rawValue)
                    
                    Text("")
                        .tabItem {
                            TabbedItem.label(for: .write)
                        }
                        .tag(TabbedItem.write.rawValue)
                    
                    ProfileScreen(showActionSheet: $showActionSheet)
                        .tabItem {
                            TabbedItem.label(for: .profile)
                        }
                        .tag(TabbedItem.profile.rawValue)
                }
                .tint(.brand500)
                
                Color.clear
                    .actionSheetForKEEV(
                        isPresented: $showActionSheet,
                        defaults: .othersProfile(
                            shareHandler: {
                                //프로필 공유하기 코드 추가해야합니다.
                                showActionSheet = false
                            },
                            reportHandler: {
                                navigateToReport = true
                                showActionSheet = false
                            })
                    )
                    .navigationDestination(isPresented: $navigateToReport) {
                        ReportScreen(reportType: .user)
                    }
            }
        }
        .tint(.gray100)
        .onChange(of: selectedItem) { oldValue, newValue in
            if newValue == TabbedItem.write.rawValue {
                isPresented = true
                selectedItem = oldValue
            }
        }
        .fullScreenCover(isPresented: $isPresented) {
            VibeCreateScreen()
        }
    }
}

#Preview {
    EntryView()
}
