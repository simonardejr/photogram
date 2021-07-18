import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'messages_store.dart';
import 'package:intl/intl.dart';

class MessagesPage extends StatefulWidget {
  final String title;
  final String id;
  final userData;
  const MessagesPage({Key? key, this.title = 'MessagesPage', required this.id, required this.userData}) : super(key: key);
  @override
  MessagesPageState createState() => MessagesPageState(id: this.id, userData: this.userData);
}
class MessagesPageState extends ModularState<MessagesPage, MessagesStore> {

  final String id;
  late final userMessage;
  late final userData;

  MessagesPageState({required this.id, required this.userData});

  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    userMessage = store.getUser(this.id);
    store.listMessages(this.userData!.id.hashCode);
    _messageController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.userData['displayName']),
      ),
      body: Column(
        children: [
          Expanded(
              child: SizedBox(
                height: 200,
                child: _userMessages(store),
              ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Flexible(
                    child: TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.mail_outline,
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(color: Colors.black26,),
                          filled: true,
                          fillColor: Colors.white24,
                          hintText: 'Mensagem'),
                    )
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        store.sendMessage(
                            message: _messageController.text,
                            destinationId: this.userData!.id.hashCode,
                            userId: store.user!.uid
                        ).then((_) {
                          _messageController.clear();
                        });

                      }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _userMessages extends StatelessWidget {

  final MessagesStore store;

  _userMessages(this.store);

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (_) {
          return StreamBuilder(
            stream: store.messagesResult,
            builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                log('Erro ao carregar: ${snapshot.error}');
                return Text('Deu erro');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasData && snapshot.data!.docs.length > 0) {

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (_, index) {
                    final message = messages[index];

                    final DateTime messageDate = message['dateTime'].toDate();

                    return (message['userId'] == store.user!.uid) ?
                        myMessages(
                          message: message['message'],
                          messageDate: messageDate
                        )
                        : otherUserMessages(
                          message: message['message'],
                          messageDate: messageDate
                        );
                  },
                );
              }
              return Container(
                padding: EdgeInsets.all(25),
                child: Text('O histórico de mensagens está vazio.'),
              );
            },
          );
        },
      );
  }
}

class myMessages extends StatelessWidget {
  late final message;
  late final messageDate;

  myMessages({required this.message, required this.messageDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left:15, top:10, right: 15, bottom: 10),
      width: 10,
      decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(message, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(DateFormat('dd/MM/yyyy kk:mm').format(messageDate).toString(), style: TextStyle(fontSize: 13),)
        ],
      ),
      margin: EdgeInsets.all(8),
    );
  }
}

class otherUserMessages extends StatelessWidget {
  late final message;
  late final messageDate;

  otherUserMessages({required this.message, required this.messageDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left:15, top:10, right: 15, bottom: 10),
      width: 10,
      decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(DateFormat('dd/MM/yyyy kk:mm').format(messageDate).toString(), style: TextStyle(fontSize: 13),)
        ],
      ),
      margin: EdgeInsets.all(8),
    );
  }
}
