import 'package:GreenConnectMobile/core/error/failure.dart';
import 'package:GreenConnectMobile/features/message/domain/usecases/get_chat_rooms_usecase.dart';
import 'package:GreenConnectMobile/features/message/domain/usecases/get_messages_usecase.dart';
import 'package:GreenConnectMobile/features/message/domain/usecases/mark_chat_room_as_read_usecase.dart';
import 'package:GreenConnectMobile/features/message/domain/usecases/send_message_usecase.dart';
import 'package:GreenConnectMobile/features/message/presentation/providers/message_providers.dart';
import 'package:GreenConnectMobile/features/message/presentation/viewmodels/states/message_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageViewModel extends Notifier<MessageState> {
  late GetChatRoomsUsecase _getChatRooms;
  late GetMessagesUsecase _getMessages;
  late SendMessageUsecase _sendMessage;
  late MarkChatRoomAsReadUsecase _markAsRead;

  @override
  MessageState build() {
    _getChatRooms = ref.read(getChatRoomsUsecaseProvider);
    _getMessages = ref.read(getMessagesUsecaseProvider);
    _sendMessage = ref.read(sendMessageUsecaseProvider);
    _markAsRead = ref.read(markChatRoomAsReadUsecaseProvider);
    return MessageState();
  }

  /// Fetch chat rooms with optional search
  Future<void> fetchChatRooms({
    String? searchQuery,
    int page = 1,
    int size = 20,
    bool loadMore = false,
  }) async {
    state = state.copyWith(
      isLoadingRooms: true,
      errorMessage: null,
      searchQuery: searchQuery,
    );

    try {
      final result = await _getChatRooms(
        name: searchQuery,
        pageNumber: page,
        pageSize: size,
      );

      state = state.copyWith(isLoadingRooms: false, chatRooms: result);
      debugPrint('✅ Fetched ${result.chatRooms.length} chat rooms');
    } on AppException catch (e) {
      debugPrint('❌ ERROR FETCH CHAT ROOMS: ${e.message}');
      state = state.copyWith(
        isLoadingRooms: false,
        errorMessage: e.message ?? 'Failed to fetch chat rooms',
      );
    }
  }

  /// Refresh chat rooms list
  Future<void> refreshChatRooms() async {
    await fetchChatRooms(searchQuery: state.searchQuery, page: 1);
  }

  /// Load next page of chat rooms
  Future<void> loadMoreChatRooms() async {
    if (!state.hasNextRoomsPage || state.isLoadingRooms) return;
    await fetchChatRooms(
      searchQuery: state.searchQuery,
      page: state.chatRooms!.nextPage!,
      loadMore: true,
    );
  }

  /// Fetch messages for a specific chat room
  Future<void> fetchMessages({
    required String chatRoomId,
    required String transactionId,
    int page = 1,
    int size = 50,
    bool loadMore = false,
  }) async {
    state = state.copyWith(
      isLoadingMessages: true,
      errorMessage: null,
      currentChatRoomId: chatRoomId,
      currentTransactionId: transactionId,
    );

    try {
      final result = await _getMessages(
        chatRoomId: chatRoomId,
        pageNumber: page,
        pageSize: size,
      );

      state = state.copyWith(isLoadingMessages: false, messages: result);
      debugPrint('✅ Fetched ${result.messages.length} messages');
    } on AppException catch (e) {
      debugPrint('❌ ERROR FETCH MESSAGES: ${e.message}');
      state = state.copyWith(
        isLoadingMessages: false,
        errorMessage: e.message ?? 'Failed to fetch messages',
      );
    }
  }

  /// Refresh messages in current chat room
  Future<void> refreshMessages() async {
    if (state.currentChatRoomId == null || state.currentTransactionId == null) {
      return;
    }
    await fetchMessages(
      chatRoomId: state.currentChatRoomId!,
      transactionId: state.currentTransactionId!,
      page: 1,
    );
  }

  /// Load older messages (pagination)
  Future<void> loadMoreMessages() async {
    if (!state.hasNextMessagesPage ||
        state.isLoadingMessages ||
        state.currentChatRoomId == null ||
        state.currentTransactionId == null) {
      return;
    }
    await fetchMessages(
      chatRoomId: state.currentChatRoomId!,
      transactionId: state.currentTransactionId!,
      page: state.messages!.nextPage!,
      loadMore: true,
    );
  }

  /// Send a message (with current transaction from state)
  Future<bool> sendMessage(String content) async {
    if (state.currentTransactionId == null || content.trim().isEmpty) {
      return false;
    }

    return await sendMessageWithTransaction(
      transactionId: state.currentTransactionId!,
      content: content,
    );
  }

  /// Send a message with explicit transactionId (for creating new chat room)
  Future<bool> sendMessageWithTransaction({
    required String transactionId,
    required String content,
  }) async {
    if (content.trim().isEmpty) {
      return false;
    }

    state = state.copyWith(
      isSendingMessage: true,
      errorMessage: null,
      currentTransactionId: transactionId,
    );

    try {
      await _sendMessage(transactionId: transactionId, content: content.trim());

      // Refresh messages if in chat detail view
      if (state.messages != null &&
          state.currentChatRoomId != null &&
          state.currentTransactionId == transactionId) {
        await refreshMessages();
      }

      state = state.copyWith(isSendingMessage: false);
      debugPrint('✅ Message sent successfully');
      return true;
    } on AppException catch (e) {
      debugPrint('❌ ERROR SEND MESSAGE: ${e.message}');
      state = state.copyWith(
        isSendingMessage: false,
        errorMessage: e.message ?? 'Failed to send message',
      );
      return false;
    }
  }

  /// Mark a chat room as read
  Future<bool> markChatRoomAsRead(String chatRoomId) async {
    state = state.copyWith(isMarkingRead: true, errorMessage: null);

    try {
      final success = await _markAsRead(chatRoomId);

      if (success) {
        await refreshChatRooms();
      }

      state = state.copyWith(isMarkingRead: false);
      debugPrint('✅ Chat room marked as read');
      return success;
    } on AppException catch (e) {
      debugPrint('❌ ERROR MARK AS READ: ${e.message}');
      state = state.copyWith(
        isMarkingRead: false,
        errorMessage: e.message ?? 'Failed to mark chat room as read',
      );
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Clear current chat room (when leaving chat)
  void clearCurrentChatRoom() {
    state = state.copyWith(
      currentChatRoomId: null,
      currentTransactionId: null,
      messages: null,
    );
  }
}
