import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:photogram/app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'register_store.g.dart';

class RegisterStore = _RegisterStoreBase with _$RegisterStore;
abstract class _RegisterStoreBase with Store {

  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;
  SharedPreferences sharedPreferences;

  _RegisterStoreBase({required this.firebaseAuth, required this.firebaseFirestore, required this.sharedPreferences}) {
    firebaseAuth.authStateChanges().listen(_onAuthChange);
  }

  @observable
  User? user;

  @observable
  bool loading = false;

  @observable
  FirebaseException? error;

  @action
  void _onAuthChange(User? user) {
    if(user?.isAnonymous ?? true) {
      this.user = null;
    } else {
      this.user = user;
    }
  }

  @action
  Future<void> registerUser({required String name, required String email, required String password}) async {
    loading = true;

    final credential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    await credential.user?.updateDisplayName(name);
    sharedPreferences.setBool(Constants.REGISTER_DONE, true);

    updateProfile(displayName: name, bio: 'Hey! Cheguei no Photogram!');

    loading = false;
  }

  @action
  Future<void> updateProfile({required String displayName, required String bio}) async {
    if(user == null) {
      return;
    }

    try {
      loading = true;

      await firebaseFirestore.doc('user/' + user!.uid).set({
        'displayName': displayName,
        'bio': bio
      }, SetOptions(merge: true));

      await firebaseAuth.currentUser?.updateDisplayName(displayName);

      loading = false;
    } on FirebaseException catch(e) {
      error = e;
      log('Erro ao salvar perfil ', error: e);
    }
  }
}