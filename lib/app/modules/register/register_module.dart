import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:photogram/app/modules/register/register_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_page.dart';

class RegisterModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => RegisterStore(
        firebaseAuth: i.get<FirebaseAuth>(),
        firebaseFirestore: i.get<FirebaseFirestore>(),
        sharedPreferences: i.get<SharedPreferences>(),
    )),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (context, args) => RegisterPage())
  ];
}
