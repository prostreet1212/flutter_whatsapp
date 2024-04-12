import 'package:flutter_whatsapp/features/user/domain/repositories/user_repository.dart';

class VerifyPhoneNumberUseCase{
  final UserRepository repository;

  VerifyPhoneNumberUseCase({required this.repository});

  Future<void> call(String phoneNumber) async{
    return repository.verifyPhoneNumber(phoneNumber);
  }
}