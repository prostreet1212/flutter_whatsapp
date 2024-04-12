import 'package:flutter_whatsapp/features/user/domain/repositories/user_repository.dart';

class SignInUseCase{
  final UserRepository repository;

  SignInUseCase({required this.repository});

  Future<void> call(String smsPinCode) async{
    return repository.signInWithPhoneNumber(smsPinCode);
  }
}