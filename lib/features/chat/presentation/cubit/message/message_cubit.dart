import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/chat_entity.dart';
import '../../../domain/entities/message_entity.dart';
import '../../../domain/repositories/get_messages_usecase.dart';
import '../../../domain/repositories/send_message_usecase.dart';
import '../../../domain/use_cases/delete_message_usecase.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final DeleteMessageUseCase deleteMessageUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  MessageCubit(
      {required this.deleteMessageUseCase,
      required this.sendMessageUseCase,
      required this.getMessagesUseCase})
      : super(MessageInitial());

  Future<void> getMessages({required MessageEntity message}) async {
    try {
      emit(MessageLoading());

      final streamResponse = getMessagesUseCase.call(message);
      streamResponse.listen((messages) {
        emit(MessageLoaded(messages: messages));
      });
    } on SocketException {
      emit(MessageFailure());
    } catch (_) {
      emit(MessageFailure());
    }
  }

  Future<void> deleteMessage({required MessageEntity message}) async {
    try {

      await deleteMessageUseCase.call(message);

    } on SocketException {
      emit(MessageFailure());
    } catch (_) {
      emit(MessageFailure());
    }
  }



  Future<void> sendMessage({required ChatEntity chat, required MessageEntity message}) async {
    try {

      await sendMessageUseCase.call(chat, message);

    } on SocketException {
      emit(MessageFailure());
    } catch (_) {
      emit(MessageFailure());
    }
  }



}
