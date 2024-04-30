import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/use_cases/user/get_all_users_usecase.dart';
import '../../../domain/use_cases/user/update_user_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UpdateUserUseCase updateUserUseCase;
  final GetAllUsersUseCase getAllUsersUseCase;

  UserCubit({
    required this.updateUserUseCase,
    required this.getAllUsersUseCase,
  }) : super(UserInitial());

  Future<void> getAllUsers(String uid) async {
    emit(UserLoading());
    final streamResponse = getAllUsersUseCase.call(uid);
    streamResponse.listen((users) {
      emit(UserLoaded(users: users));
    });
  }

  Future<void> updateUser({required UserEntity user}) async {
    try {
      await updateUserUseCase.call(user);
    } catch (e) {
      emit(UserFailure());
    }
  }

}
