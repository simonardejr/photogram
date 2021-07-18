import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photogram/app/constants.dart';
import 'package:photogram/app/modules/feed/feed_store.dart';

class FeedPage extends StatefulWidget {
  final String title;
  const FeedPage({Key? key, this.title = 'FeedPage'}) : super(key: key);
  @override
  FeedPageState createState() => FeedPageState();
}
class FeedPageState extends ModularState<FeedPage, FeedStore> {
  
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
        title: Text('Photogram'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.add_box_outlined)
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite_border_outlined)
          ),
          IconButton(
              onPressed: () {
                Modular.to.pushNamed(Constants.Routes.MESSAGES_USER_LIST);
              },
              icon: Icon(Icons.chat_bubble_outline)
          )
        ],
      ),
      body: StreamBuilder(
        stream: store.posts,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            final posts = snapshot.data!.docs;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
              final post = posts[index];
              return Column(
                children: [
                  FutureBuilder(
                    future: store.getUser(post['userId']),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if(snapshot.hasData) {
                        final user = snapshot.data!.data() as Map<String, dynamic>;
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: _profilePic(user),
                              ),
                              SizedBox(width: 8),
                              Text(user['displayName'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
                            ],
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  SizedBox(height: 8,),
                  Image.network(
                    post['url'],
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover
                  ),
                  SizedBox(height: 8,),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.favorite_border_outlined)
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.chat_bubble_outline_outlined)
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.share_outlined)
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.bookmark_border_rounded)
                      ),
                    ],
                  )
                ],
              );
            });
          }
          return Container();
        },
      ),
    );
  }
}