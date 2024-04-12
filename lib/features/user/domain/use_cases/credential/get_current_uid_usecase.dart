

import 'package:flutter_whatsapp/features/user/domain/repositories/user_repository.dart';

class GetCurrentUidUseCase{
  final UserRepository repository;

  GetCurrentUidUseCase({required this.repository});

  Future<String> call() async{
    return repository.getCurrentUID();
  }
}