//
//  EventDetailScreen.swift
//  KEEV
//
//  Created by Doran on 11/17/24.
//

import SwiftUI

/// 섹션을 정의하는 열거형
///
/// - detail: 공연 상세 정보
/// - vibe: 사람들이 남긴 공연에 대한 바이브
///
/// - Author: Doran
enum EventDetailSection: Int, CaseIterable {
    case detail = 0
    case vibe = 1
    
    var title: String {
        switch self {
        case .detail: return "공연 상세"
        case .vibe: return "바이브"
        }
    }
}

/// 이벤트 상세 스크린
///
/// - Parameter selectedEvent: 상세 정보를 표시할 이벤트 객체
///
/// - Author: Doran
struct EventDetailScreen: View {
    @State private var selectedEvent: DetailEventUIO
    @State private var vibeWriteState: VibeWriteState
    @State private var activeSection = EventDetailSection.detail
    @State private var isPresented: Bool = false //시트의 유무를 나타내는 Bool 타입 변수
    @State private var vibeCount: Int? = nil
    
    init(selectedEvent: DetailEventUIO) {
        self.selectedEvent = selectedEvent
        let dDay = selectedEvent.dDay ?? 0
        self.vibeWriteState = dDay >= 0 ? .loading : .writeYet(for: dDay)
    }
    var body: some View {
        VStack(spacing: 0){
            HeaderTabView(activeSection: $activeSection, dDay: selectedEvent.dDay, vibeCount: nil)
            switch activeSection {
            case .detail:
                infoView
            case .vibe:
                vibeView
            }
        }
        .backgroundForKEEV()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(selectedEvent.name)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .regular)))
                    .frame(width: 277)
                    .foregroundStyle(.gray300)
                    
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.gray100)
                }
            }
        }
    }
}

extension EventDetailScreen {
    /// 이벤트 상세 정보 뷰
    ///
    /// - Returns: 이벤트 상세 정보를 표시하는 뷰.
    ///
    /// - Author: Doran
    private var infoView: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                EventDetailThumbnail(selectedEvent: selectedEvent)
                    .padding(.top,4)
                EventDetailInfoView(selectedEvent: selectedEvent)
                    .padding(.horizontal, 20)
                
                detailSection
            }
            
            CommonButton(title: "\(vibeWriteState)", action: { print("hello world") }, style: .maxWidth, disabled: isDisabled)
                .padding(EdgeInsets(top: 12, leading: 16, bottom: 0, trailing: 16))
        }
    }
    
    /// 바이브 뷰
    ///
    /// - Returns: 바이브 정보를 표시하는 뷰
    ///
    /// - Author: Doran
    @ViewBuilder
    private var vibeView: some View {
        VStack(spacing: 0){
            if (isDisabled) {
                yetStartVibe.frame(maxHeight: .infinity)
            }
            else {
                EventVibeHeader().padding(.horizontal, 16)
                EventVibeView(eventID: selectedEvent.id)
            }
        }
    }
    
    /// 공연이 시작되지 않았을 때 표시되는 뷰
    ///
    /// - Returns: 공연이 시작되지 않았음을 알리는 뷰
    ///
    /// - Author: Doran
    private var yetStartVibe: some View {
        VStack(spacing: 0){
            Text("공연이 시작되지 않았습니다.")
                .figmaFont(PretendardFont.title(style: .sm))
                .foregroundColor(.gray500)
            Text("공연이 시작되면 바이브를 작성할 수 있어요.")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                .foregroundColor(.gray500)
        }
    }
    
    
    private var detailSection: some View {
        VStack(spacing: 12) {
            VStack(spacing: 12) {
                HStack {
                    Text("공연 상세 정보")
                        .figmaFont(PretendardFont.title(style: .sm))
                    Spacer()
                }
                
                if let description = selectedEvent.description {
                    descriptionPart(text: description)
                }
            }
            .padding(.horizontal, 20)
            detailImagePart
        }
    }
    
    private var detailImagePart: some View {
        VStack(spacing: 0) {
            ForEach(selectedEvent.descriptionImageURLs, id: \.self) { url in
                URLCachedImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else if phase.error == nil {
                        ProgressView()
                    } else {
                        let _ = print(phase.error!)
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
        }
    }
    
    /// 공연 상세 설명을 표시하는 부분
    ///
    /// - Author: newJunsung
    private func descriptionPart(text: String) -> some View {
        Text(text)
            .foregroundStyle(.gray50)
            .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium)))
    }
}



extension EventDetailScreen {
    /// 이벤트 시작 여부를 판단하는 연산 프로퍼티
    ///
    /// - Returns: 이벤트가 시작되지 않았다면 true, 그렇지 않다면 false를 반환.
    ///
    /// - Author: Doran
    private var isDisabled: Bool {
        if vibeWriteState == .canWrite {
            return true
        }
        return false
    }
}

extension EventDetailScreen {
    enum VibeWriteState: CustomStringConvertible, Equatable {
        case writeYet(for: Int)
        case loading
        case canWrite
        case alreadyWritten
        
        var description: String {
            switch self {
            case .writeYet(let dDay):
                return "D\(dDay)"
            case .loading: return "로딩 중..."
            case .canWrite: return "글쓰기"
            case .alreadyWritten: return "작성 완료"
            }
        }
    }
}

#Preview {
    NavigationStack {
        EventDetailScreen(selectedEvent: .dummy2)
    }
}
