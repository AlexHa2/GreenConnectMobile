import 'package:GreenConnectMobile/features/message/data/datasources/message_remote_datasource.dart';
import 'package:GreenConnectMobile/features/message/data/datasources/message_remote_datasource_impl.dart';
import 'package:GreenConnectMobile/features/message/data/repository/message_repository_impl.dart';
import 'package:GreenConnectMobile/features/message/domain/repository/message_repository.dart';
import 'package:GreenConnectMobile/features/message/domain/usecases/get_chat_rooms_usecase.dart';
import 'package:GreenConnectMobile/features/message/domain/usecases/get_messages_usecase.dart';
import 'package:GreenConnectMobile/features/message/domain/usecases/mark_chat_room_as_read_usecase.dart';
import 'package:GreenConnectMobile/features/message/domain/usecases/send_message_usecase.dart';
import 'package:GreenConnectMobile/features/message/presentation/viewmodels/message_view_model.dart';
import 'package:GreenConnectMobile/features/message/presentation/viewmodels/states/message_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ==================
///  Remote DataSource
/// ==================
final messageRemoteDsProvider = Provider<MessageRemoteDataSource>((ref) {
  return MessageRemoteDataSourceImpl();
});

/// =============
///  Repository
/// =============
final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  final ds = ref.read(messageRemoteDsProvider);
  return MessageRepositoryImpl(ds);
});

/// =============
///  UseCases
/// =============

// Get chat rooms
final getChatRoomsUsecaseProvider = Provider<GetChatRoomsUsecase>((ref) {
  return GetChatRoomsUsecase(ref.read(messageRepositoryProvider));
});

// Get messages
final getMessagesUsecaseProvider = Provider<GetMessagesUsecase>((ref) {
  return GetMessagesUsecase(ref.read(messageRepositoryProvider));
});

// Send message
final sendMessageUsecaseProvider = Provider<SendMessageUsecase>((ref) {
  return SendMessageUsecase(ref.read(messageRepositoryProvider));
});

// Mark chat room as read
final markChatRoomAsReadUsecaseProvider = Provider<MarkChatRoomAsReadUsecase>((
  ref,
) {
  return MarkChatRoomAsReadUsecase(ref.read(messageRepositoryProvider));
});

/// =============
///  ViewModel
/// =============
final messageViewModelProvider =
    NotifierProvider<MessageViewModel, MessageState>(() => MessageViewModel());
