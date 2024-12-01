//
//  VibeDetailScreen.swift
//  KEEV
//
//  Created by 김준성 on 11/19/24.
//

import SwiftUI

// -MARK: 스크린 핵심부
struct VibeDetailScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    @Injected private var replyService: any ReplyServiceProtocol
    @Injected private var vibeService: any VibeServiceProtocol
    
    @State private var vibe: VibeUIO
    @State private var replies: [ReplyUIO] = []
    
    private let onDelete: ((VibeUIO) -> Void)?
    
    @State private var errorForAlert: Error? = nil
    @State private var loadingForDelete: Bool = false
    @State private var imageIndexTag: Int = 0
    @State private var replyText: String = ""
    
    @State private var showVibeActionSheet: Bool = false
    @State private var showReplyActionSheet: ReplyWithIndex? = nil
    @State private var modifyReplySheet: ReplyWithIndex? = nil
    @State private var navigateToModifyVibe: Bool = false
    @State private var navigateToReport: ReportType? = nil
    @State private var navigateToUserProfile: Int? = nil
    
    init(
        vibe: VibeUIO,
        onUpdate: ((VibeUIO) -> Void)? = nil,
        onDelete: ((VibeUIO) -> Void)? = nil
    ) {
        self.vibe = vibe
        self.onDelete = onDelete
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    VibeContentView(vibe: vibe)
                        .padding(.top, 20)
                        .padding(.horizontal, 16)
                    ReplyListView(
                        userID: 2,
                        replies: $replies,
                        userTapHandler: tapReplyUser,
                        moreTapHandler: tapReplyMore,
                        likeTapHandler: tapReplyLike
                    )
                    .background(.grayBG700)
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .scrollIndicators(.hidden)
            .refreshable {
                fetchVibe()
                fetchReplies()
            }
            
            ReplyInputView(replyText: $replyText, sendHandler: addReply)
            .padding(.top, 16)
            .padding(.horizontal, 20)
            .background(.grayBG800)
        }
        .navigationTitle("바이브")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.gray100)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showVibeActionSheet = true
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.gray100)
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
            ModifyReplyView(reply: replies[index]) { updatedText in
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
            VibeModifyScreen(vibe: $vibe)
        }
        .navigationDestination(item: $navigateToUserProfile) { userID in
            ProfileScreen(userID: userID, isMyProfile: vibe.isMine, isNavigation: true)
        }
        .onAppear(perform: fetchReplies)
        .loading(for: loadingForDelete)
        .alertForError($errorForAlert)
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
    
    func tapReplyMore(index: Int, reply: ReplyUIO) {
        showReplyActionSheet = .init(index: index, reply: reply)
    }
    
    func tapReplyUser(for userID: Int) {
        navigateToUserProfile = userID
    }
    
    func tapReplyLike(index: Int, reply: ReplyUIO) {
        // 좋아요를 눌렀을 때 문제 해결
    }
    
    func fetchVibe() {
        Task {
            do {
                vibe = try await vibeService.getVibeWithVibeID(vibeID: vibe.id)
            } catch {
                errorForAlert = error
                print("바이브를 불러오는데 실패했습니다.")
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
                print("바이브를 삭제하는데 실패했습니다.")
            }
        }
    }
    
    func fetchReplies() {
        Task {
            do {
                replies = try await replyService.fetchReplies(for: vibe.id)
            } catch {
                print("댓글을 불러오는데 실패했습니다.")
            }
        }
    }
    
    func addReply(_ text: String) {
        replyText = ""
        Task {
            do {
                let reply = try await replyService.addReply(to: vibe.id, text: text)
                replies.insert(reply, at: 0)
                
            } catch {
                errorForAlert = error
                print("댓글을 등록하는데 실패했습니다.")
            }
        }
    }
    
    func modifyReply(index: Int, reply: ReplyUIO, text: String) {
        modifyReplySheet = nil
        Task {
            do {
                let reply = try await replyService.modifyReply(reply, updatedText: text)
                replies[index] = reply
            } catch {
                errorForAlert = error
                print("댓글을 수정하는데 실패했습니다.")
            }
        }
    }
    
    func deleteReply(reply: ReplyWithIndex) {
        Task {
            do {
                try await replyService.deleteReply(reply.id)
                replies.remove(at: reply.index)
            } catch {
                errorForAlert = error
                print("댓글을 삭제하는데 실패했습니다.")
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

#Preview {
    NavigationStack {
        VibeDetailScreen(vibe: .dummy2) { _ in
            
        } onDelete: { _ in
            
        }
    }
}
