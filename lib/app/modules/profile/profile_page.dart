import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photogram/app/constants.dart';
import 'package:photogram/app/modules/profile/user_store.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  ProfilePageState createState() => ProfilePageState();
}
class ProfilePageState extends ModularState<ProfilePage, UserStore> {
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
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.add_box_outlined)
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          _userHeader(store),
          _userSubHeader(store),
          _userGallery(),

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
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/img6.png'),
                    radius: 38,
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
                Text('blab blvlkaslaskdh ladlkah dlkjahd lkashdlk ahdlka shdlkas hlkahd'),
                ElevatedButton(
                    onPressed: () {
                      Modular.to.pushNamed('.' + Constants.Routes.EDIT_PROFILE);
                    },
                    child: Text('Editar Perfil')
                )
              ],
            ),
          );
  }
}

class _userGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 1,
                shrinkWrap: true,
                children: [
                  Image.network('http://lorempixel.com/300/300/?${DateTime.now().microsecondsSinceEpoch}', width: 100, height: 100,),
                  Image.network('http://lorempixel.com/300/300/?${DateTime.now().microsecondsSinceEpoch}', width: 100, height: 100,),
                  Image.network('http://lorempixel.com/300/300/?${DateTime.now().microsecondsSinceEpoch}', width: 100, height: 100,),
                  Image.network('http://lorempixel.com/300/300/?${DateTime.now().microsecondsSinceEpoch}', width: 100, height: 100,),
                  Image.network('http://lorempixel.com/300/300/?${DateTime.now().microsecondsSinceEpoch}', width: 100, height: 100,),
                  Image.network('http://lorempixel.com/300/300/?${DateTime.now().microsecondsSinceEpoch}', width: 100, height: 100,),
                  Image.network('http://lorempixel.com/300/300/?${DateTime.now().microsecondsSinceEpoch}', width: 100, height: 100,),
                  Image.network('http://lorempixel.com/300/300/?${DateTime.now().microsecondsSinceEpoch}', width: 100, height: 100,),
                  Image.network('http://lorempixel.com/300/300/?${DateTime.now().microsecondsSinceEpoch}', width: 100, height: 100,),
                  Image.network('http://lorempixel.com/300/300/?${DateTime.now().microsecondsSinceEpoch}', width: 100, height: 100,),
                  Image.network('http://lorempixel.com/300/300/?${DateTime.now().microsecondsSinceEpoch}', width: 100, height: 100,),
                  Image.network('http://lorempixel.com/300/300/?${DateTime.now().microsecondsSinceEpoch}', width: 100, height: 100,),
                  Image.network('http://lorempixel.com/300/300/?${DateTime.now().microsecondsSinceEpoch}', width: 100, height: 100,),
                  Image.network('http://lorempixel.com/300/300/?${DateTime.now().microsecondsSinceEpoch}', width: 100, height: 100,),
                  Image.network('http://lorempixel.com/300/300/?${DateTime.now().microsecondsSinceEpoch}', width: 100, height: 100,),
                  Image.network('http://lorempixel.com/300/300/?${DateTime.now().microsecondsSinceEpoch}', width: 100, height: 100,),
                ],
            ),
          );
  }
}
