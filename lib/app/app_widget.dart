import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photogram/app/light_theme.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChannels.textInput.invokeMethod('TextInput.hide');

    return MaterialApp(
      title: 'Photogram',
      theme: lightTheme,
      // darkTheme: ,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    ).modular();
  }
}