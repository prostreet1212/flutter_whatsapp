import 'package:flutter_whatsapp/features/user/domain/use_cases/credential/get_current_uid_usecase.dart';
import 'package:flutter_whatsapp/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:flutter_whatsapp/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:flutter_whatsapp/features/user/presentation/cubit/get_device_number/get_device_number_cubit.dart';
import 'package:flutter_whatsapp/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';
import 'package:flutter_whatsapp/features/user/presentation/cubit/user/user_cubit.dart';

import '../../main_injection_container.dart';
import 'data/data_sources/remote/user_remote_data_source.dart';
import 'data/data_sources/remote/user_remote_data_source_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/use_cases/credential/is_sign_in_usecase.dart';
import 'domain/use_cases/credential/sign_in_with_phone_number_usecase.dart';
import 'domain/use_cases/credential/sign_out_usecase.dart';
import 'domain/use_cases/credential/verify_phone_number_usecase.dart';
import 'domain/use_cases/user/create_user_usecase.dart';
import 'domain/use_cases/user/get_all_users_usecase.dart';
import 'domain/use_cases/user/get_device_number_usecase.dart';
import 'domain/use_cases/user/get_single_user_usecase.dart';
import 'domain/use_cases/user/update_user_usecase.dart';

Future<void> userInjectionContainer() async {
  // * CUBITS INJECTION
  sl.registerFactory<AuthCubit>(() => AuthCubit(
        getCurrentUidUseCase: sl.call(),
        isSignInUseCase: sl.call(),
        signOutUseCase: sl.call(),
      ));

  sl.registerFactory<UserCubit>(() => UserCubit(
      getAllUsersUseCase: sl.call(),
      updateUserUseCase: sl.call()
  ));

  sl.registerFactory<GetSingleUserCubit>(() => GetSingleUserCubit(
      getSingleUserUseCase: sl.call()
  ));

  sl.registerFactory<CredentialCubit>(() => CredentialCubit(
      createUserUseCase: sl.call(),
      signInWithPhoneNumberUseCase: sl.call(),
      verifyPhoneNumberUseCase: sl.call()
  ));

  sl.registerFactory<GetDeviceNumberCubit>(() => GetDeviceNumberCubit(
      getDeviceNumberUseCase: sl.call()
  ));

  // * USE CASES INJECTION
  
  sl.registerLazySingleton<GetCurrentUidUseCase>(()
  => GetCurrentUidUseCase(repository: sl.call()));

  sl.registerLazySingleton<IsSignInUseCase>(
          () => IsSignInUseCase(repository: sl.call()));

  sl.registerLazySingleton<SignOutUseCase>(
          () => SignOutUseCase(repository: sl.call()));

  sl.registerLazySingleton<CreateUserUseCase>(
          () => CreateUserUseCase(repository: sl.call()));

  sl.registerLazySingleton<GetAllUsersUseCase>(
          () => GetAllUsersUseCase(repository: sl.call()));

  sl.registerLazySingleton<UpdateUserUseCase>(
          () => UpdateUserUseCase(repository: sl.call()));

  sl.registerLazySingleton<GetSingleUserUseCase>(
          () => GetSingleUserUseCase(repository: sl.call()));

  sl.registerLazySingleton<SignInWithPhoneNumberUseCase>(
          () => SignInWithPhoneNumberUseCase(repository: sl.call()));

  sl.registerLazySingleton<VerifyPhoneNumberUseCase>(
          () => VerifyPhoneNumberUseCase(repository: sl.call()));

  sl.registerLazySingleton<GetDeviceNumberUseCase>(
          () => GetDeviceNumberUseCase(repository: sl.call()));
  // * REPOSITORY & DATA SOURCES INJECTION
  sl.registerLazySingleton<UserRepository>(
          () => UserRepositoryImpl(remoteDataSource: sl.call()));

  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(
    auth: sl.call(),
    fireStore: sl.call(),
  ));
}


