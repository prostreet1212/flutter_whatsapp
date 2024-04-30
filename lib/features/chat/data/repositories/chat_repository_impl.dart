import 'package:flutter_whatsapp/features/chat/data/remote/chat_remote_data_source.dart';
import 'package:flutter_whatsapp/features/chat/domain/entities/chat_entity.dart';
import 'package:flutter_whatsapp/features/chat/domain/entities/message_entity.dart';
import 'package:flutter_whatsapp/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl extends ChatRepository{

ChatRemoteDataSource chatRemoteDataSource;

ChatRepositoryImpl({required this.chatRemoteDataSource});

  @override
  Future<void> deleteChat(ChatEntity chat) async{
     chatRemoteDataSource.deleteChat(chat);
  }

  @override
  Future<void> deleteMessage(MessageEntity message) async{
     chatRemoteDataSource.deleteMessage(message);
  }

  @override
  Stream<List<MessageEntity>> getMessages(MessageEntity message) {
    return chatRemoteDataSource.getMessages(message);
  }

  @override
  Stream<List<ChatEntity>> getMyChat(ChatEntity chat) {
    return chatRemoteDataSource.getMyChat(chat);
  }

  @override
  Future<void> seenMessageUpdate(MessageEntity message) {
    return chatRemoteDataSource.seenMessageUpdate(message);
  }

  @override
  Future<void> sendMessage(ChatEntity chat, MessageEntity message) {
    return chatRemoteDataSource.sendMessage(chat, message);
  }

}