import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'features/user/user_injection_container.dart';

final sl=GetIt.instance;


Future<void> init() async{

  final auth=FirebaseAuth.instance;
  final fireStore=FirebaseFirestore.instance;

  await userInjectionContainer();

}