//
//  VibeDetailScreen.swift
//  KEEV
//
//  Created by 김준성 on 11/19/24.
//

import SwiftUI

/// 어떤 경로로 바이브 상세 스크린으로 접근했는지를 알기 위한 열거형
///
/// 네비게이션 라우터 구현시 제일 마지막의 스택에 따른 판별로 대체 가능할 것 같습니다.
///
/// - Author: Doran
enum VibeDetailPath {
    case event
    case feed
}

// -MARK: 스크린 핵심부
struct VibeDetailScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    @Injected private var replyService: any ReplyServiceProtocol
    @Injected private var vibeService: any VibeServiceProtocol
    
    @Binding private var vibe: VibeUIO
    @State private var replies: [ReplyUIO] = []
    
    private let vibeDetailPath: VibeDetailPath
    private let onDelete: ((VibeUIO) -> Void)?
    private let onUpdate: ((VibeUIO) -> Void)?
    
    @State private var errorForAlert: Error? = nil
    @State private var loadingForDelete: Bool = false
    @State private var imageIndexTag: Int = 0
    @State private var replyText: String = ""
    @State private var toggleAdd: Bool = false
    
    @State private var showVibeActionSheet: Bool = false
    @State private var showReplyActionSheet: ReplyWithIndex? = nil
    @State private var modifyReplySheet: ReplyWithIndex? = nil
    @State private var navigateToModifyVibe: Bool = false
    @State private var navigateToReport: ReportType? = nil
    @State private var navigateToUserProfile: Int? = nil
    
    @FocusState private var isFocused: Bool
    
    init(
        vibe: Binding<VibeUIO>,
        vibeDetailpath: VibeDetailPath = .event,
        onUpdate: ((VibeUIO) -> Void)? = nil,
        onDelete: ((VibeUIO) -> Void)? = nil
    ) {
        self._vibe = vibe
        self.vibeDetailPath = vibeDetailpath
        self.onUpdate = onUpdate
        self.onDelete = onDelete
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 0) {
                        eventInfo
                        VibeContentView(vibe: $vibe, likeTapHandler: tapVibeLike)
                            .padding(.top, 20)
                            .padding(.horizontal, 16)
                        Rectangle().frame(height: 1).foregroundColor(.gray800)
                        ReplyListView(
                            userID: 2,
                            replies: $replies,
                            userTapHandler: tapReplyUser,
                            moreTapHandler: tapReplyMore,
                            likeTapHandler: tapReplyLike
                        )
                        .id("replyList")
                        .background(.grayBG700)
                    }
                }
                .scrollDismissesKeyboard(.immediately)
                .scrollIndicators(.hidden)
                .refreshable {
                    fetchVibe()
                    fetchReplies()
                }
                
                ReplyInputView(replyText: $replyText, isFocused: $isFocused, sendHandler: addReply)
                    .frame(height: 46)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                    .padding(.horizontal, 20)
                    .background(.grayBG800)
            }
            .navigationTitle(vibe.event.name)
            .navigationBarTitleDisplayMode(.inline)
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
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showVibeActionSheet = true
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.gray100)
                    }
                }
            }
            .actionSheetForKEEV(
                isPresented: $showVibeActionSheet,
                defaults: vibeActionSheetContent()
            )
            .actionSheetForKEEV(
                isPresented: .init {
                    showReplyActionSheet != nil
                } set: { bool in
                    if !bool {
                        showReplyActionSheet = nil
                    }
                },
                defaults: replyActionSheetContent(selectedReply: showReplyActionSheet)
            )
            .sheet(item: $modifyReplySheet, onDismiss: {
                modifyReplySheet = nil
            }, content: { replyToModify in
                let index = replyToModify.index
                ModifyReplyView(reply: replies[index], isFocused: $isFocused) { updatedText in
                    modifyReply(index: index, reply: replies[index], text: updatedText)
                }
                .presentationDetents([.height(120)])
                .presentationDragIndicator(.visible)
            })
            .backgroundForKEEV()
            .navigationDestination(item: $navigateToReport) { type in
                ReportScreen(reportType: type)
            }
            .navigationDestination(isPresented: $navigateToModifyVibe) {
                VibeModifyScreen(vibe: $vibe, onUpdate: onUpdate)
            }
            .onAppear{
                fetchVibe()
                fetchReplies()
            }
            .onChange(of: toggleAdd) {
                withAnimation {
                    proxy.scrollTo("replyList", anchor: .bottom)
                }
            }
            .loading(for: loadingForDelete)
            .alertForError($errorForAlert)
        }
    }
}

// MARK: 스크린의 로직
private extension VibeDetailScreen {
    func vibeActionSheetContent() -> [KEEVActionSheet.ButtonConfiguration] {
        if vibe.isMine {
            return .myVibe {
                showVibeActionSheet = false
                navigateToModifyVibe = true
            } deleteHandler: {
                showVibeActionSheet = false
                deleteVibe()
            }
        } else {
            return [
                .report(title: "신고하기") {
                    navigateToReport = .vibe(eventID: vibe.event.id, vibeID: vibe.id)
                }
            ]
        }
    }
    
    func replyActionSheetContent(selectedReply: ReplyWithIndex?) -> [KEEVActionSheet.ButtonConfiguration] {
        if let reply = selectedReply?.reply,
           reply.isMine { // 서비스로부터 id를 가져와야 합니다.
            return .myComment {
                showReplyActionSheet = nil
                modifyReplySheet = selectedReply
            } deleteHandler: {
                guard let selectedReply else { return }
                deleteReply(reply: selectedReply)
                showReplyActionSheet = nil
            }
            
        } else {
            return .othersComment {
                if let reply = selectedReply?.reply {
                    showReplyActionSheet = nil
                    navigateToReport = .reply(vibeID: vibe.id, replyID: reply.id)
                }
            }
        }
    }
    
    func checkIfUserLikedVibe() {
        Task {
            do {
                vibe.isLiked = try await vibeService.checkIfUserLikedVibe(vibeID: vibe.id)
            } catch {
                errorForAlert = error
            }
        }
    }
    
    func tapVibeLike() {
        Task {
            do {
                switch vibe.isLiked {
                case true:
                    vibe.isLiked = try await vibeService.cancelLikeVibe(vibeID: vibe.id)
                    vibe.likeCount -= 1
                case false:
                    vibe.isLiked = try await vibeService.likeVibe(vibeID: vibe.id)
                    vibe.likeCount += 1
                }
            } catch {
                errorForAlert = error
            }
        }
    }
    
    func tapReplyMore(index: Int, reply: ReplyUIO) {
        showReplyActionSheet = .init(index: index, reply: reply)
    }
    
    func tapReplyUser(for userID: Int) {
        navigateToUserProfile = userID
    }
    
    func tapReplyLike(index: Int, reply: ReplyUIO) {
        Task {
            do {
                switch reply.isLiked {
                case true:
                    replies[index].isLiked = try await replyService.cancelLikeReply(replyID: reply.id)
                    replies[index].likeCount -= 1
                case false:
                    replies[index].isLiked = try await replyService.likeReply(replyID: reply.id)
                    replies[index].likeCount += 1
                }
            } catch {
                errorForAlert = error
            }
        }
    }
    
    func fetchVibe() {
        Task {
            do {
                vibe = try await vibeService.getVibeWithVibeID(vibeID: vibe.id)
            } catch {
                errorForAlert = error
                debugPrint("바이브를 불러오는데 실패했습니다.")
            }
        }
    }
    
    func deleteVibe() {
        loadingForDelete = true
        Task {
            do {
                try await vibeService.deleteVibe(vibeID: vibe.id)
                onDelete?(vibe)
                loadingForDelete = false
                dismiss()
            } catch {
                loadingForDelete = false
                errorForAlert = error
            }
        }
    }
    
    func fetchReplies() {
        Task {
            do {
                replies = try await replyService.fetchReplies(for: vibe.id)
            } catch {
                debugPrint("댓글을 불러오는데 실패했습니다.")
            }
        }
    }
    
    func addReply(_ text: String) {
        isFocused = false
        replyText = ""
        Task {
            do {
                let reply = try await replyService.addReply(to: vibe.id, text: text)
                replies.append(reply)
                vibe.replyCount += 1
                onUpdate?(vibe)
                toggleAdd.toggle()
            } catch {
                errorForAlert = error
            }
        }
    }
    
    func modifyReply(index: Int, reply: ReplyUIO, text: String) {
        isFocused = false
        modifyReplySheet = nil
        Task {
            do {
                let reply = try await replyService.modifyReply(reply, updatedText: text)
                replies[index] = reply
            } catch {
                errorForAlert = error
            }
        }
    }
    
    func deleteReply(reply: ReplyWithIndex) {
        Task {
            do {
                try await replyService.deleteReply(reply.id)
                replies.remove(at: reply.index)
                vibe.replyCount -= 1
                onUpdate?(vibe)
            } catch {
                errorForAlert = error
            }
        }
    }
}

private extension VibeDetailScreen {
    struct ReplyWithIndex: Identifiable {
        /// reply의 id입니다.
        var id: Int { reply.id }
        
        let index: Int
        let reply: ReplyUIO
    }
}

private extension VibeDetailScreen {
    @ViewBuilder
    var eventInfo: some View {
        switch vibeDetailPath {
        case .feed:
            NavigationLink{
                EventDetailScreen(simpleEvent: vibe.event)
            } label: {
                VibeFeedEventInfoCell(eventData: vibe.event)
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 4, trailing: 16))
            }
        case .event:
            EmptyView()
        }
    }
}

#Preview {
    NavigationStack {
        VibeDetailScreen(vibe: .constant(.dummy2), vibeDetailpath: .feed) { _ in
            
        } onDelete: { _ in
            
        }
    }
}
