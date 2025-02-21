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
    @Environment(AppState.self) private var appState
    
    @State private var isPresented = false
    @State private var selectedItem = TabbedItem.info.rawValue
    @State private var tmpSelectedItem = TabbedItem.info.rawValue
    @State private var userID: Int? = nil
    
    init() {
        let appearance = UITabBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(.grayBG950)
        appearance.shadowColor = UIColor(.grayBG500)
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            if let signInStatus = appState.loginStatus {
                switch signInStatus {
                case .failed:
                    SignInScreen()
                case .ok(_), .lookAround:
                    signInSuccessView
                case .created:
                    SignUpScreen(status: signInStatus)
                }
            } else {
                LaunchScreen()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onChange(of: appState.loginStatus) {
            if case let .ok(user) = appState.loginStatus {
                userID = user.id
                if tmpSelectedItem == TabbedItem.write.rawValue {
                    Task {
                        try await Task.sleep(nanoseconds: 300_000_000)
                        selectedItem = tmpSelectedItem
                    }
                }
                if tmpSelectedItem == TabbedItem.profile.rawValue {
                    selectedItem = tmpSelectedItem
                }
            }
            else {
                userID = nil
                selectedItem = TabbedItem.info.rawValue
            }
        }
        .tint(.gray100)
    }
    
    private var signInSuccessView: some View {
        TabView(selection: $selectedItem) {
            EventInfoScreen(selectedItem: $selectedItem)
                .tabItem {
                    TabbedItem.label(for: .info)
                }
                .tag(TabbedItem.info.rawValue)
            
            // 바이브 피드 탭으로 교체해주어야합니다.
            VibeFeedScreen(selectedItem: $selectedItem)
                .tabItem {
                    TabbedItem.label(for: .feed)
                }
                .tag(TabbedItem.feed.rawValue)
            
            Text("")
                .tabItem {
                    TabbedItem.label(for: .write)
                }
                .tag(TabbedItem.write.rawValue)
            
            TotalSearchScreen()
                .tabItem {
                    TabbedItem.label(for: .search)
                }
                .tag(TabbedItem.search.rawValue)
            
            ProfileScreen(
                selectedItem: $selectedItem,
                userID: userID,
                isMyProfile: userID == nil ? false : true,
                isNavigation: false
            )
            .tabItem {
                TabbedItem.label(for: .profile)
            }
            .tag(TabbedItem.profile.rawValue)
        }
        .tint(.brand500)
        .sensoryFeedback(.impact, trigger: selectedItem)
        .onChange(of: selectedItem) { oldValue, newValue in
            if case .lookAround = appState.loginStatus {
                let restrictedTabs = [TabbedItem.write.rawValue, TabbedItem
                    .profile.rawValue]
                if restrictedTabs.contains(newValue) {
                    selectedItem = oldValue
                    tmpSelectedItem = newValue
                    _ = appState.checkLoginStatus()
                }
            }
            else {
                if newValue == TabbedItem.write.rawValue {
                    isPresented = true
                    selectedItem = oldValue
                }
            }
        }
        .fullScreenCover(isPresented: $isPresented) {
            VibeCreateScreen(selectedEvent: nil, isNavigation: false)
        }
    }
}

private extension EntryView {
    struct LaunchScreen: View {
        @Injected private var service: any AccountServiceProtocol
        
        var body: some View {
            Image("LogoLargeImage")
                .resizable()
                .frame(width: 250, height: 103.5)
                .task {
                    _ = await service.autoSignIn()
                }
        }
    }
}

#Preview {
    EntryView()
}
