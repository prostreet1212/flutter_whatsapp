import 'package:flutter_whatsapp/features/user/domain/repositories/user_repository.dart';

class SignOutUseCase{
  final UserRepository repository;

  SignOutUseCase({required this.repository});

  Future<void> call() async{
    return repository.signOut();
  }
}