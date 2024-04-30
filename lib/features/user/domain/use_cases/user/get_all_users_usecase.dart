

import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';

class GetAllUsersUseCase {
  final UserRepository repository;

  GetAllUsersUseCase({required this.repository});

  Stream<List<UserEntity>> call(String uid) {
    return repository.getAllUsers( uid);
  }

}