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
struct EventDetailScreen: LoginCheckableView {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) var appState
    
    @Injected private var eventService: any EventServiceProtocol
    @Injected private var vibeService: any VibeServiceProtocol
    
    @State private var selectedEvent: DetailEventUIO
    @State private var vibeWriteState: VibeWriteState = .loading
    @State private var activeSection = EventDetailSection.detail
    @State private var showEventDetailSheet = false
    @State private var navigateToReportEvent = false
    @State private var navigateToWriteVibe = false
    @State private var navigateToDetailVibe: VibeUIO?
    
    private let isLoadDetailEvent: Bool
    
    init(detailEvent: DetailEventUIO) {
        self.selectedEvent = detailEvent
        self.isLoadDetailEvent = false
    }
    
    init(simpleEvent: SimpleEventUIO) {
        self.selectedEvent = DetailEventUIO(simpleEventUIO: simpleEvent)
        self.isLoadDetailEvent = true
    }
    
    var body: some View {
        VStack(spacing: 0){
            HeaderTabView(activeSection: $activeSection, dDay: selectedEvent.dDay, vibeCount: selectedEvent.vibeCount)
            switch activeSection {
            case .detail:
                infoView
            case .vibe:
                vibeView
            }
        }
        .backgroundForKEEV()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.gray100)
                }
            }
            
            ToolbarItem(placement: .navigation) {
                Text(selectedEvent.name)
                    .figmaFont(PretendardFont.title(style: .xs))
                    .foregroundStyle(.gray300)
                
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: determineSheetForSection) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.gray100)
                }
            }
        }
        .actionSheetForKEEV(isPresented: $showEventDetailSheet, configurations: [
            KEEVActionSheet.ButtonConfiguration.report(title: "신고하기") {
                checkLoginBefore {
                    navigateToReportEvent = true
                }
            }
        ])
        .navigationDestination(isPresented: $navigateToReportEvent) {
            ReportScreen(reportType: .event(eventID: selectedEvent.id))
        }
        .task {
            if isLoadDetailEvent {
                await loadDetailEvent()
            }
            
            await checkUserWroteVibe()
        }
        .refreshable {
            await loadDetailEvent()
            await getEventCount()
        }
        .navigationDestination(isPresented: $navigateToWriteVibe) {
            VibeCreateScreen(selectedEvent: SimpleEventUIO(detailEventUIO: selectedEvent), isNavigation: true)
        }
        .navigationDestination(item: $navigateToDetailVibe) { vibe in
            VibeDetailScreen(vibe: .constant(vibe))
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
                EventDetailInfoView(selectedEvent: selectedEvent, isFavorite: $selectedEvent.isInterested, likeCount: $selectedEvent.interestCount)
                    .padding(.horizontal, 20)
                    .onChange(of: selectedEvent.isInterested) { _, newValue in
                        Task {
                            if newValue {
                                await addEventLike()
                            } else {
                                await deleteEventLike()
                            }
                        }
                    }
                
                detailSection
            }
            
            CommonButton(title: "\(vibeWriteState)", action: {
                checkLoginBefore {
                    if case let .alreadyWritten(vibe) = vibeWriteState {
                        navigateToDetailVibe = vibe
                    } else {
                        navigateToWriteVibe = true
                    }
                }
            }, style: .maxWidth, disabled: vibeWriteState.isDisabled)
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
            if (vibeWriteState.isDisabled) {
                yetStartVibe.frame(maxHeight: .infinity)
            }
            else {
                VStack(spacing: 0) {
                    EventVibeView(event: selectedEvent)
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    /// 공연이 시작되지 않았을 때 표시되는 뷰
    ///
    /// - Returns: 공연이 시작되지 않았음을 알리는 뷰
    ///
    /// - Author: Doran
    private var yetStartVibe: some View {
        VStack(spacing: 4){
            Text("공연이 시작되지 않았습니다")
                .figmaFont(PretendardFont.title(style: .sm))
                .foregroundColor(.gray500)
            Text("공연이 시작되면 바이브를 작성할 수 있어요")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                .foregroundColor(.gray500)
        }
    }
    
    
    private var detailSection: some View {
        VStack(spacing: 12) {
            if selectedEvent.description != nil
                || !selectedEvent.descriptionImageURLs.isEmpty {
                HStack {
                    Text("공연 상세 정보")
                        .figmaFont(PretendardFont.title(style: .xs))
                    Spacer()
                }
            }
            
            if let description = selectedEvent.description {
                if (description != ""){
                    descriptionPart(text: description)
                }
            }
            
            if !selectedEvent.descriptionImageURLs.isEmpty {
                detailImagePart
            }
        }
        .padding(.horizontal, 20)
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
                        let _ = debugPrint(phase.error ?? "unknown error")
                        Image("PosterError")
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
        HStack(spacing: 0){
            Text(text.splitWords())
                .foregroundStyle(.gray100)
                .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .medium)))
            Spacer()
        }
    }
    
    private func determineSheetForSection() {
        switch activeSection {
        case .detail: showEventDetailSheet = true
        case .vibe: showEventDetailSheet = true // 신고 시트가 올라와야 함.
        }
    }
    
    private func loadDetailEvent() async {
        do {
            selectedEvent = try await eventService.loadDetailEvent(id: selectedEvent.id)
        } catch let failToFetchEvent {
            appState.presentError(failToFetchEvent)
        }
    }
    
    private func getIsLiked() async {
        selectedEvent.isInterested = (try? await eventService.getIsLikedEvent(id: selectedEvent.id)) ?? false
    }
    
    private func getEventCount() async {
        do {
            selectedEvent.interestCount = try await eventService.getEventLikeCount(id: selectedEvent.id)
        } catch(let failToFetchEventLikeCount) {
            appState.presentError(failToFetchEventLikeCount)
        }
    }
    
    private func addEventLike() async {
        do {
            selectedEvent.isInterested = try await eventService.addEventLike(id: selectedEvent.id)
        } catch let failToAddInterest {
            appState.presentError(failToAddInterest)
        }
    }
    
    private func deleteEventLike() async {
        do {
            selectedEvent.isInterested = try await eventService.deleteEventLike(id: selectedEvent.id)
        } catch let failToDeleteInterest {
            appState.presentError(failToDeleteInterest)
        }
    }
    
    private func checkUserWroteVibe() async {
        let dDay = selectedEvent.dDay ?? 0
        guard dDay >= 0 else {
            vibeWriteState = .writeYet(for: dDay)
            return
        }
        
        
        do {
            let id = try await vibeService.checkIfUserUploadedVibe(eventID: selectedEvent.id)
            let vibe = try? await vibeService.getVibeWithVibeID(vibeID: id)
            vibeWriteState = .alreadyWritten(vibe: vibe)
        } catch {
            vibeWriteState = .canWrite
        }
    }
}

extension EventDetailScreen {
    enum VibeWriteState: CustomStringConvertible, Equatable {
        case writeYet(for: Int)
        case loading
        case canWrite
        case alreadyWritten(vibe: VibeUIO?)
        
        var description: String {
            switch self {
            case .writeYet(let dDay):
                return "D\(dDay)"
            case .loading: return "로딩 중..."
            case .canWrite: return "글쓰기"
            case .alreadyWritten: return "이미 바이브를 작성했어요!"
            }
        }
        
        var isDisabled: Bool {
            switch self {
            case .writeYet, .loading:
                return true
            case .alreadyWritten(let vibe):
                return vibe == nil
            case .canWrite:
                return false
            }
        }
    }
}

#Preview {
    NavigationStack {
        EventDetailScreen(simpleEvent: .dummy0)
    }
}
