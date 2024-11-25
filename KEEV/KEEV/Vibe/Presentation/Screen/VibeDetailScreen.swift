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
    
    @State private var vibe: VibeUIO
    @State private var replies: [ReplyUIO] = []
    
    private let onUpdate: ((VibeUIO) -> Void)?
    private let onDelete: ((VibeUIO) -> Void)?
    
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
        self.onUpdate = onUpdate
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
                // vibeservice로부터 바이브 정보를 가져오면 됩니다.
                // replyservice로부터 댓글을 가져오면 됩니다.
            }
            
            ReplyInputView(replyText: $replyText) { _ in
                // replyservice에서 댓글을 다는 메소드를 호출, ReplyUIO 반환
                // 반환이 되면 그걸 `replies`에 삽입.
                // 에러 처리는 해줘야겠죠?
                replyText = ""
            }
            .padding(.top, 16)
            .padding(.horizontal, 20)
            .background(.grayBG800)
        }
        .navigationTitle("바이브")
        .navigationBarTitleDisplayMode(.inline)
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
            ModifyReplyView(reply: replies[index]) { _ in
                // replyservice로 댓글 수정을 요청하고
                // 리턴받은 UIO로 replies[index]를 갈아끼운다.
                // 에러 처리는 선택이 아닌 필수.
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
            VStack {
                Text("userID: \(userID)")
                Text("유저 프로필 뷰로 이동해야 함.")
            }
        }
        .task {
            // ReplyService에서 댓글을 불러오는 함수를 호출하면 됨.
            replies = [
                .dummy0,
                .dummy1,
                .dummy3,
                .dummy2
            ]
        }
    }
}

// MARK: 스크린의 로직
private extension VibeDetailScreen {
    func sendReply() {
        print(replyText)
        // ReplyService에서 무언가를 수행하면 됩니다.
        // 성공하면 replies에 replyUIO를 넣으면 됩니다.
    }
    
    func vibeActionSheetContent() -> [KEEVActionSheet.ButtonConfiguration] {
        if 2 == vibe.userID {
            return .myVibe {
                showVibeActionSheet = false
                print("feeeeee")
                navigateToModifyVibe = true
            } deleteHandler: {
                showVibeActionSheet = false
                /// 삭제를 시도하는 api가 있어야 합니다.
                onDelete?(vibe)
                dismiss()
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
        if 2 == selectedReply?.reply.userID { // 서비스로부터 id를 가져와야 합니다.
            return .myComment {
                showReplyActionSheet = nil
                modifyReplySheet = selectedReply
            } deleteHandler: {
                guard let selectedReply else { return }
                // 댓글 삭제하는 api 호출
                replies.remove(at: selectedReply.index) // 성공하면 삭제, 실패하면 에러 처리
                showReplyActionSheet = nil
            }
            
        } else {
            return .othersComment {
                if let reply = selectedReply?.reply {
                    showReplyActionSheet = nil
                    navigateToReport = .comment(vibeID: vibe.id, replyID: reply.id)
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
        VibeDetailScreen(vibe: .dummy5) { _ in
            
        } onDelete: { _ in
            
        }
    }
}
