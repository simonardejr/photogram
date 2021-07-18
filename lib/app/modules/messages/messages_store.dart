import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

part 'messages_store.g.dart';

class MessagesStore = _MessagesStoreBase with _$MessagesStore;
abstract class _MessagesStoreBase with Store {

  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;

  _MessagesStoreBase({required this.firebaseAuth, required this.firebaseFirestore}) {
    firebaseAuth.userChanges().listen(_onUserChange);
  }

  @observable
  bool loading = false;

  @observable
  User? user;

  @observable
  FirebaseException? error;

  @action
  void _onUserChange(User? user) {
    this.user = user;
  }

  Future<DocumentSnapshot> getUser(String userId) async {
    return firebaseFirestore.doc('user/' + userId).get();
  }

  @observable
  Stream<QuerySnapshot> usersResult = Stream.empty();

  @action
  Future<void> listUsers() async {
    /*
     * Excluindo o usuário logado da lista de mensagens
     */
    usersResult.drain();
    usersResult = firebaseFirestore.collection('user')
      .where('displayName', isNotEqualTo: firebaseAuth.currentUser?.displayName)
      .orderBy('displayName')
      .snapshots();
  }

  @observable
  Stream<QuerySnapshot> messagesResult = Stream.empty();

  @action
  Future<void> listMessages(destinationId) async {
    messagesResult.drain();

    late final groupChatId;
    if (firebaseAuth.currentUser!.uid.hashCode <= destinationId) {
        groupChatId = '${firebaseAuth.currentUser!.uid.hashCode}-$destinationId';
    } else {
        groupChatId = '$destinationId-${firebaseAuth.currentUser!.uid.hashCode}';
    }

    messagesResult = firebaseFirestore.collection('messages')
      .doc(groupChatId)
      .collection(groupChatId)
      .orderBy('dateTime')
      .snapshots();
  }

  @action
  Future<void> sendMessage({required String message, required destinationId, required String userId}) async {
    if(user == null) {
      return;
    }
    try {
      loading = true;

      late final groupChatId;
      if (firebaseAuth.currentUser!.uid.hashCode <= destinationId) {
          groupChatId = '${firebaseAuth.currentUser!.uid.hashCode}-$destinationId';
      } else {
          groupChatId = '$destinationId-${firebaseAuth.currentUser?.uid.hashCode}';
      }

      await firebaseFirestore.collection('messages/').doc(groupChatId).collection(groupChatId).add({
        'dateTime': DateTime.now(),
        'message': message,
        'destinationId': destinationId,
        'userId': userId
      });

      loading = false;
    } on FirebaseException catch(e) {
      error = e;
      log('Erro ao enviar mensagem ', error: e);
    }
  }
}