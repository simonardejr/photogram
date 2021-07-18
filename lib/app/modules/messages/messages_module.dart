import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:photogram/app/modules/messages/messages_page.dart';
import 'package:photogram/app/modules/messages/messages_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'user_list_page.dart';

class MessagesModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => MessagesStore(
      firebaseAuth: i.get<FirebaseAuth>(),
      firebaseFirestore: i.get<FirebaseFirestore>(),
    )),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (context, args) => UserListPage()),
    ChildRoute('/:id', child: (_, args) => MessagesPage(id: args.params['id'], userData: args.data),
    ),
  ];
}
