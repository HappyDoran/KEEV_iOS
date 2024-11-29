//
//  LazyView.swift
//  KEEV
//
//  Created by 김준성 on 11/28/24.
//

import SwiftUI

/// 뷰를 늦게 생성해주는 뷰
///
/// NavigationLink는 미리 destination으로 연결된 뷰를 초기화합니다.
///
/// 이때, 수 백개의 리스트의 Cell이 NavigationLink를 사용하게 되면 성능상으로 이슈가 되기도 하지만,
///
/// SwiftUI가 다음 네비게이션의 목적지가 어디인지 몰라서 문제가 생길 수 있습니다.
///
/// 이를 해결하기 위해, 뷰를 늦게 생성할 수 있도록 LazyView를 만들게 되었습니다.
///
/// LazyVStack, LazyVGrid, List 내부에서 NavigationLink를 사용할 일이 있다면 이 뷰로 감싸서 사용해주시기 바랍니다.
///
///
/// 사용법은 아래와 같습니다.
/// ```swift
/// NavigationLink(destination: LazyView(Text("hello world!")) {
///     Text("next View")
/// }
/// 
/// ```
///
/// - Author: newJunsung
struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

#Preview {
    LazyView(EntryView())
}
