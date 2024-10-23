//
//  CustomAlert.swift
//  KEEV
//
//  Created by Doran on 10/23/24.
//

import SwiftUI

struct CustomAlert: View {
    @State private var showAlert = false

    var body: some View {
        VStack {
            Button("Show Alert") {
                showAlert = true
            }
            .customAlert(title: "잠깐!",
                         message: "공연을 변경하면 작성하던 내용이 사라집니다.\n다른 공연을 선택하시겠어요?",
                         isPresented: $showAlert,
                         leftButtonText: "취소",
                         rightButtonText: "공연 변경",
                         leftAction: {print("취소")},
                         rightAction: {print("공연 변경")}
            )
        }
    }
}

#Preview {
    CustomAlert()
}
