import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:photogram/app/constants.dart';
import 'package:photogram/app/modules/profile/user_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'profile_page.dart';
import 'edit_page.dart';

class ProfileModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => UserStore(
        firebaseAuth: i.get<FirebaseAuth>(),
        firebaseFirestore: i.get<FirebaseFirestore>(),
        firebaseStorage: i.get<FirebaseStorage>()
    )),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (context, args) => ProfilePage()),
    ChildRoute(Constants.Routes.EDIT_PROFILE, child: (context, args) => EditPage(), transition: TransitionType.rightToLeftWithFade)

  ];
}
