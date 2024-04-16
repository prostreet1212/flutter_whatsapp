import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/use_cases/user/get_single_user_usecase.dart';

part 'get_single_user_state.dart';

class GetSingleUserCubit extends Cubit<GetSingleUserState> {
  final GetSingleUserUseCase getSingleUserUseCase;

  GetSingleUserCubit({required this.getSingleUserUseCase}) : super(GetSingleUserInitial());

  Future<void> getSingleUser({required String uid}) async {
    emit(GetSingleUserLoading());
    Stream<List<UserEntity>> streamResponse = getSingleUserUseCase.call(uid);
    streamResponse.listen((users) {
      emit(GetSingleUserLoaded(singleUser: users.first));
    });
  }

}
