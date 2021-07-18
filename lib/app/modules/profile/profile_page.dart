import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photogram/app/constants.dart';
import 'package:photogram/app/modules/profile/user_store.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  ProfilePageState createState() => ProfilePageState();
}
class ProfilePageState extends ModularState<ProfilePage, UserStore> {

  late final ImagePicker _picker;

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Observer(
                    builder: (_) {
                      return Text((store.user?.displayName ?? 'Sem nome'), style: TextStyle(fontWeight: FontWeight.bold));
                    }
                ),
        actions: [
          Observer(builder: (_) {
            if(store.loading) {
              return Container(
                child: Center(
                  child: Transform.scale(
                    scale: 0.5,
                    child: CircularProgressIndicator(color: Theme.of(context).buttonColor)),
                ),
              );
            }
            return IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (ctx) {
                      return Container(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              child: Row(
                                children: [
                                  Icon(Icons.camera_alt_outlined),
                                  SizedBox(width: 16),
                                  Text('Tirar foto')
                                ],
                              ),
                              onTap: () async {
                                final pickedFile = await _picker.pickImage(
                                    source: ImageSource.camera,
                                    imageQuality: 50,
                                    maxWidth: 1920,
                                    maxHeight: 1280,
                                );
                                if(pickedFile != null) {
                                  store.postPicture(pickedFile.path);
                                }
                                Navigator.of(ctx).pop();
                              },
                            ),
                            SizedBox(height: 24),
                            InkWell(
                              child: Row(
                                children: [
                                  Icon(Icons.photo_library_outlined),
                                  SizedBox(width: 16),
                                  Text('Escolher foto')
                                ],
                              ),
                              onTap: () async {
                                final pickedFile = await _picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 50,
                                    maxWidth: 1920,
                                    maxHeight: 1280,
                                );
                                if(pickedFile != null) {
                                  store.postPicture(pickedFile.path);
                                }
                                Navigator.of(ctx).pop();
                              },
                            )
                          ],
                        ),
                      );
                    }
                );
              },
              icon: Icon(Icons.add_box_outlined)
            );
          })
        ],
      ),
      body: ListView(
        children: <Widget>[
          _userHeader(store),
          _userSubHeader(store),
          _userGallery(store),

        ],
      ),
    );
  }
}

class _userHeader extends StatelessWidget {

  UserStore store;
  _userHeader(this.store);

  @override
  Widget build(BuildContext context) {
    return Container(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 40,
                  child: Observer(
                    builder: (_) {
                      if(store.user!.photoURL != null && store.user!.photoURL!.isNotEmpty) {
                        return CircleAvatar(
                          radius: 38,
                          backgroundImage: NetworkImage(store.user!.photoURL!),
                        );
                      }
                      return CircleAvatar(
                        radius: 38,
                        backgroundImage: AssetImage('assets/img6.png'),
                      );
                    },
                  ),
                ),
                Column(
                  children: [
                    Text('100', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text('Publicações')
                  ],
                ),
                Column(
                  children: [
                    Text('200', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text('Seguidores')
                  ],
                ),
                Column(
                  children: [
                    Text('300', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text('Seguindo')
                  ],
                )
              ],
            ),
          );
  }
}

class _userSubHeader extends StatelessWidget {

  UserStore store;
  _userSubHeader(this.store);

  @override
  Widget build(BuildContext context) {
    return Container(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Observer(
                    builder: (_) {
                      return Text((store.user?.displayName ?? 'Sem nome'), style: TextStyle(fontWeight: FontWeight.bold));
                    }
                ),
                Observer(builder: (_) {
                  return Text(store.bio ?? '');
                }),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Modular.to.pushNamed('.' + Constants.Routes.EDIT_PROFILE);
                        },
                        label: Text('Editar Perfil')
                    ),
                    ElevatedButton.icon(
                        icon: Icon(Icons.logout),
                        onPressed: () {
                          store.logoff().then((_) => Modular.to.pushNamed(Constants.Routes.LOGIN));
                        },
                        label: Text('Logoff')
                    ),
                  ],
                )
              ],
            ),
          );
  }
}

class _userGallery extends StatelessWidget {

  final UserStore store;

  _userGallery(this.store);

  @override
  Widget build(BuildContext context) {
    return Container(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: StreamBuilder(
              stream: store.posts,
              builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(snapshot.hasError) {
                  log('Erro ao carregar: ${snapshot.error}');
                  return Text('Aconteceu um erro inesperado.');
                }
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if(snapshot.hasData && snapshot.data!.docs.length > 0) {
                  final posts = snapshot.data!.docs;
                  return GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                      physics: NeverScrollableScrollPhysics(),
                      childAspectRatio: 1,
                      shrinkWrap: true,
                      children: posts.map((post) {
                        final data = post.data() as Map<String, dynamic>;
                        return Image.network(data['url'] as String, fit: BoxFit.cover,);
                      }).toList()
                  );
                }

                return Container();
              },
            )
          );
  }
}
