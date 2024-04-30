import 'package:flutter_whatsapp/features/user/data/data_sources/remote/user_remote_data_source.dart';
import 'package:flutter_whatsapp/features/user/domain/entities/contact_entity.dart';
import 'package:flutter_whatsapp/features/user/domain/entities/user_entity.dart';
import 'package:flutter_whatsapp/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createUser(UserEntity user) async =>
      remoteDataSource.createUser(user);

  @override
  Stream<List<UserEntity>> getAllUsers(String uid) => remoteDataSource.getAllUsers(uid);

  @override
  Future<String> getCurrentUID() async => remoteDataSource.getCurrentUID();

  @override
  Future<List<ContactEntity>> getDeviceNumber() async =>
      remoteDataSource.getDeviceNumber();

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) =>
      remoteDataSource.getSingleUser(uid);

  @override
  Future<bool> isSignIn() async => remoteDataSource.isSignIn();

  @override
  Future<void> signInWithPhoneNumber(String smsPinCode) =>
      remoteDataSource.signInWithPhoneNumber(smsPinCode);

  @override
  Future<void> signOut() async => remoteDataSource.signOut();

  @override
  Future<void> updateUser(UserEntity user) async =>
      remoteDataSource.updateUser(user);

  @override
  Future<void> verifyPhoneNumber(String phoneNumber) async =>
      remoteDataSource.verifyPhoneNumber(phoneNumber);
}
