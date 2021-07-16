import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photogram/app/constants.dart';
import 'package:mobx/mobx.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentTab = 0;
  
  @override
  void initState() {
    super.initState();
    _onTabChange(_currentTab);
  }

  void _onTabChange(int index) {
    setState(() {
      _currentTab = index;
    });
    switch(index) {
      case 0:
        Modular.to.navigate(Constants.Routes.HOME + Constants.Routes.FEED);
        break;
      case 1:
        Modular.to.navigate(Constants.Routes.HOME + Constants.Routes.SEARCH);
        break;
      case 2:
        Modular.to.navigate(Constants.Routes.HOME + Constants.Routes.PROFILE);
        break;
      default: break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RouterOutlet(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onTabChange,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Buscar',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded),
              label: 'Perfil'
          ),
        ],
      ),
    );
  }
}
