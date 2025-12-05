import 'package:GreenConnectMobile/core/di/profile_injector.dart';
import 'package:GreenConnectMobile/core/network/token_storage.dart';
import 'package:GreenConnectMobile/features/message/presentation/providers/message_providers.dart';
import 'package:GreenConnectMobile/features/message/presentation/views/widgets/chat_app_bar.dart';
import 'package:GreenConnectMobile/features/message/presentation/views/widgets/chat_input_area.dart';
import 'package:GreenConnectMobile/features/message/presentation/views/widgets/chat_message_list.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modern Chat Detail Page with infinity scroll
class ChatDetailPage extends ConsumerStatefulWidget {
  final String chatRoomId;
  final String transactionId;
  final String partnerName;
  final String? partnerAvatar;

  const ChatDetailPage({
    super.key,
    required this.chatRoomId,
    required this.transactionId,
    required this.partnerName,
    this.partnerAvatar,
  });

  @override
  ConsumerState<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends ConsumerState<ChatDetailPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  String _currentUserId = '';
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    debugPrint('🚀 ChatDetailPage initState called');
    _setupScrollListener();
    // Must load user ID BEFORE fetching messages
    _initializeChat();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Initialize chat: load user ID, messages, mark as read
  Future<void> _initializeChat() async {
    await _loadUserId();
    await _loadMessages();
    await _markAsRead();
  }

  /// Load current user ID from TokenStorage
  Future<void> _loadUserId() async {
    final tokenStorage = sl<TokenStorageService>();
    final user = await tokenStorage.getUserData();
    if (user != null && mounted) {
      setState(() => _currentUserId = user.userId);
    }
  }

  /// Load initial messages
  Future<void> _loadMessages() async {
    await ref
        .read(messageViewModelProvider.notifier)
        .fetchMessages(
          chatRoomId: widget.chatRoomId,
          transactionId: widget.transactionId,
        );
  }

  /// Mark chat room as read
  Future<void> _markAsRead() async {
    await ref
        .read(messageViewModelProvider.notifier)
        .markChatRoomAsRead(widget.chatRoomId);
  }

  /// Setup scroll listener for infinity scroll
  void _setupScrollListener() {
    _scrollController.addListener(() {
      // Load more older messages when scrolling near the top
      if (_scrollController.position.pixels <=
              _scrollController.position.minScrollExtent + 100 &&
          !_isLoadingMore) {
        _loadMoreMessages();
      }
    });
  }

  /// Load more older messages (pagination)
  Future<void> _loadMoreMessages() async {
    final state = ref.read(messageViewModelProvider);
    if (!state.hasNextMessagesPage || state.isLoadingMessages) return;

    setState(() => _isLoadingMore = true);
    await ref.read(messageViewModelProvider.notifier).loadMoreMessages();
    if (mounted) {
      setState(() => _isLoadingMore = false);
    }
  }

  /// Scroll to bottom (latest message)
  void _scrollToBottom({bool animated = true}) {
    if (!_scrollController.hasClients) return;

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_scrollController.hasClients) return;

      if (animated) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  /// Pull to refresh
  Future<void> _onRefresh() async {
    await ref.read(messageViewModelProvider.notifier).refreshMessages();
  }

  /// Send message
  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    // Clear input and unfocus
    _messageController.clear();
    _focusNode.unfocus();

    // Send via ViewModel
    final success = await ref
        .read(messageViewModelProvider.notifier)
        .sendMessage(content);

    if (success && mounted) {
      // Scroll to bottom after sending
      await Future.delayed(const Duration(milliseconds: 300));
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(messageViewModelProvider);
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;

    // Auto-scroll when new message is sent
    ref.listen(messageViewModelProvider, (previous, next) {
      if (previous != null &&
          previous.isSendingMessage &&
          !next.isSendingMessage &&
          next.errorMessage == null &&
          next.hasMessages) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }

      // Auto-scroll when first load messages
      if (previous != null && !previous.hasMessages && next.hasMessages) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _scrollToBottom(animated: false),
        );
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChatAppBar(
        chatRoomId: widget.chatRoomId,
        partnerName: widget.partnerName,
        partnerAvatar: widget.partnerAvatar,
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(child: _buildMessagesList(state, theme, spacing, s)),
          // Error Banner
          if (state.errorMessage != null)
            _buildErrorBanner(state, theme, spacing),
          // Input Area
          ChatInputArea(
            controller: _messageController,
            focusNode: _focusNode,
            onSend: _sendMessage,
            isSending: state.isSendingMessage,
          ),
        ],
      ),
    );
  }

  /// Build messages list with states
  Widget _buildMessagesList(
    dynamic state,
    ThemeData theme,
    AppSpacing spacing,
    S s,
  ) {
    // Initial Loading
    if (state.isLoadingMessages &&
        state.messages == null &&
        state.errorMessage == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: theme.primaryColor,
              strokeWidth: 3,
            ),
            SizedBox(height: spacing.screenPadding),
            Text(
              s.loading,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    // Error State
    if (state.errorMessage != null &&
        state.messages == null &&
        !state.isLoadingMessages) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(spacing.screenPadding * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: theme.colorScheme.error.withValues(alpha: 0.7),
              ),
              SizedBox(height: spacing.screenPadding),
              Text(
                state.errorMessage!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.screenPadding * 1.5),
              FilledButton.icon(
                onPressed: _loadMessages,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(s.retry),
                style: FilledButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.screenPadding * 2,
                    vertical: spacing.screenPadding,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Empty State
    if (state.messages != null &&
        !state.hasMessages &&
        !state.isLoadingMessages) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(spacing.screenPadding * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 80,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              SizedBox(height: spacing.screenPadding),
              Text(
                s.message_no_messages,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: spacing.screenPadding / 2),
              Text(
                s.message_no_messages_description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Messages List with ChatMessageList widget
    return ChatMessageList(
      messages: state.messages!.messages,
      currentUserId: _currentUserId,
      scrollController: _scrollController,
      isLoadingMore: _isLoadingMore,
      onRefresh: _onRefresh,
    );
  }

  /// Build error banner
  Widget _buildErrorBanner(dynamic state, ThemeData theme, AppSpacing spacing) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.screenPadding / 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.error.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: theme.colorScheme.onErrorContainer,
            size: 20,
          ),
          SizedBox(width: spacing.screenPadding / 2),
          Expanded(
            child: Text(
              state.errorMessage!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close_rounded,
              color: theme.colorScheme.onErrorContainer,
              size: 20,
            ),
            onPressed: () {
              ref.read(messageViewModelProvider.notifier).clearError();
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
