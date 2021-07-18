import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photogram/app/constants.dart';
import 'messages_store.dart';

class UserListPage extends StatefulWidget {
  final String title;
  const UserListPage({Key? key, this.title = 'Mensagens'}) : super(key: key);
  @override
  UserListPageState createState() => UserListPageState();
}
class UserListPageState extends ModularState<UserListPage, MessagesStore> {

  @override
  void initState() {
    super.initState();
    store.listUsers();
  }

  ImageProvider _profilePic(data) {
    late ImageProvider userProfile;
    try {
      if(data.get('profilePic') != null) {
        userProfile = NetworkImage(data['profilePic']);
      }
    } catch (e, s) {
      userProfile = AssetImage('assets/img6.png');
      print(s);
      print('O documento não possui uma profilePic, usando o default. $e');
    }
    return userProfile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Observer(
        builder: (_) {
          return StreamBuilder(
            stream: store.usersResult,
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

                final users = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (_, index) {
                    final user = users[index];

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey))
                      ),
                      child: InkWell(
                        onTap: () {
                          Modular.to.pushNamed(Constants.Routes.MESSAGES_FROM_USER + user.reference.id, arguments: user);
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundImage: _profilePic(user),
                            ),
                            SizedBox(width: 12),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user['displayName'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return Container(
                child: Text('Vazio'),
              );
            },
          );
        },
      ),
    );
  }
}