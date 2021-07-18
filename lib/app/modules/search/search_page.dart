import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photogram/app/modules/search/search_store.dart';


class SearchPage extends StatefulWidget {
  final String title;
  const SearchPage({Key? key, this.title = 'Encontrar Pessoas'}) : super(key: key);
  @override
  SearchPageState createState() => SearchPageState();
}
class SearchPageState extends ModularState<SearchPage, SearchStore> {

  bool _searching = false;
  FocusNode focusNode = FocusNode();
  late final TextEditingController _searchController;


  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      final query = _searchController.text;
      store.search(query);
    });
  }

  Widget _searchField() {
    final color = Theme.of(context).buttonColor;
    return TextFormField(
      focusNode:  focusNode,
      controller: _searchController,
      decoration: InputDecoration(
        icon: Icon(Icons.search, color: color,),
        fillColor: color,
        focusColor: color,
        hoverColor: color
      ),
      cursorColor: color,
      style: TextStyle(color: color),
    );
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

  Widget _textDisplaName(data) {
    late Text displayName;
    try {
      if(data.get('displayName') != null) {
        displayName = Text(data['displayName'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),);
      }
    } catch (e, s) {
      displayName = Text('Sem nome', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),);
      print(s);
      print('O documento não possui um displayName, usando o default. $e');
    }
    return displayName;
  }
  
  Widget _textBio(data) {
    late Text textBio;
    try {
      if(data.get('displayName') != null) {
        textBio = Text(data['bio']);
      }
    } catch (e, s) {
      textBio = Text('Sem bio');
      print(s);
      print('O documento não possui uma bio, usando o default. $e');
    }
    return textBio;
  }

  late Widget searchingWidget = Observer(
    builder: (_) {
      return StreamBuilder(
        stream: store.searchResult,
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
            if (_searchController.text.length == 0) {
              return Container();
            }

            final users = snapshot.data!.docs;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (_, index) {
                final user = users[index];

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                          _textDisplaName(user),
                          _textBio(user)
                        ],
                      )
                    ],
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
  );


  late Widget notSearchingWidget = StreamBuilder(
    stream: store.posts,
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
        final posts = snapshot.data!.docs;
        return GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            childAspectRatio: 1,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: posts.map((post) {
              final data = post.data() as Map<String, dynamic>;
              return Image.network(data['url'] as String, fit: BoxFit.cover);
            }).toList()
        );
      }
      return Container();
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searching ? _searchField() : Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(_searching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _searching = !_searching;
              });
              focusNode.requestFocus();
            },
          )
        ],
      ),
      body: _searching ? searchingWidget : notSearchingWidget,
    );
  }
}