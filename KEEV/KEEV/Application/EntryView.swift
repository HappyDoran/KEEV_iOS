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
    @State private var signInStatus: SignInStatus? = nil
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
            if let signInStatus {
                switch signInStatus {
                case .failed:
                    SignInScreen(status: $signInStatus)
                case .ok(_):
                    signInSuccessView
                case .created:
                    SignUpScreen(status: $signInStatus)
                }
            } else {
                LaunchScreen(status: $signInStatus)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onChange(of: signInStatus) {
            if case let .ok(user) = signInStatus {
                userID = user.id
            }
        }
        .tint(.gray100)
        .onReceive(
            NotificationCenter.Publisher
                .signInStatusPublisher
                .receive(on: DispatchQueue.main)
        ) { status in
            selectedItem = TabbedItem.info.rawValue
            signInStatus = status
        }
    }
    
    private var signInSuccessView: some View {
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
            
            ProfileScreen(
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
            if newValue == TabbedItem.write.rawValue {
                isPresented = true
                selectedItem = oldValue
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
        @Binding var status: SignInStatus?
        
        var body: some View {
            Image("LogoLargeImage")
                .resizable()
                .frame(width: 250, height: 103.5)
                .task {
                    status = await service.autoSignIn()
                }
        }
    }
}

#Preview {
    EntryView().environmentObject(VibeManager())
}
