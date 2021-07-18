// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MessagesStore on _MessagesStoreBase, Store {
  final _$loadingAtom = Atom(name: '_MessagesStoreBase.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$userAtom = Atom(name: '_MessagesStoreBase.user');

  @override
  User? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$errorAtom = Atom(name: '_MessagesStoreBase.error');

  @override
  FirebaseException? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(FirebaseException? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  final _$usersResultAtom = Atom(name: '_MessagesStoreBase.usersResult');

  @override
  Stream<QuerySnapshot<Object?>> get usersResult {
    _$usersResultAtom.reportRead();
    return super.usersResult;
  }

  @override
  set usersResult(Stream<QuerySnapshot<Object?>> value) {
    _$usersResultAtom.reportWrite(value, super.usersResult, () {
      super.usersResult = value;
    });
  }

  final _$messagesResultAtom = Atom(name: '_MessagesStoreBase.messagesResult');

  @override
  Stream<QuerySnapshot<Object?>> get messagesResult {
    _$messagesResultAtom.reportRead();
    return super.messagesResult;
  }

  @override
  set messagesResult(Stream<QuerySnapshot<Object?>> value) {
    _$messagesResultAtom.reportWrite(value, super.messagesResult, () {
      super.messagesResult = value;
    });
  }

  final _$listUsersAsyncAction = AsyncAction('_MessagesStoreBase.listUsers');

  @override
  Future<void> listUsers() {
    return _$listUsersAsyncAction.run(() => super.listUsers());
  }

  final _$listMessagesAsyncAction =
      AsyncAction('_MessagesStoreBase.listMessages');

  @override
  Future<void> listMessages(dynamic destinationId) {
    return _$listMessagesAsyncAction
        .run(() => super.listMessages(destinationId));
  }

  final _$sendMessageAsyncAction =
      AsyncAction('_MessagesStoreBase.sendMessage');

  @override
  Future<void> sendMessage(
      {required String message,
      required dynamic destinationId,
      required String userId}) {
    return _$sendMessageAsyncAction.run(() => super.sendMessage(
        message: message, destinationId: destinationId, userId: userId));
  }

  final _$_MessagesStoreBaseActionController =
      ActionController(name: '_MessagesStoreBase');

  @override
  void _onUserChange(User? user) {
    final _$actionInfo = _$_MessagesStoreBaseActionController.startAction(
        name: '_MessagesStoreBase._onUserChange');
    try {
      return super._onUserChange(user);
    } finally {
      _$_MessagesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
user: ${user},
error: ${error},
usersResult: ${usersResult},
messagesResult: ${messagesResult}
    ''';
  }
}
