import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:photogram/app/constants.dart';
import 'package:photogram/app/modules/register/register_store.dart';

class RegisterPage extends StatefulWidget {
  final String title;
  const RegisterPage({Key? key, this.title = 'Cadastre-se'}) : super(key: key);
  @override
  RegisterPageState createState() => RegisterPageState();
}
class RegisterPageState extends ModularState<RegisterPage, RegisterStore> {

  late PageController _pageController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  late final ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _disposer = when(
      (_) => store.user != null,
      () => Modular.to.pushReplacementNamed('/home')//Constants.Routes.HOME)
    );
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }

  late final Widget _form = PageView(
    scrollDirection: Axis.vertical,
    controller: _pageController,
    physics: NeverScrollableScrollPhysics(),
    children: [
      _FormField(
        controller: _nameController,
        label: "Qual é o seu nome?",
        showsBackButton: false,
        onNext: () { _pageController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.easeInOut); },
        onBack: () { _pageController.previousPage(duration: Duration(milliseconds: 400), curve: Curves.easeInOut); },
      ),
      _FormField(
        controller: _emailController,
        label: "Qual é o seu melhor email?",
        showsBackButton: true,
        onNext: () { _pageController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.easeInOut); },
        onBack: () { _pageController.previousPage(duration: Duration(milliseconds: 400), curve: Curves.easeInOut); },
      ),
      _FormField(
        controller: _passwordController,
        label: "Crie a sua senha",
        showsBackButton: true,
        onNext: () {
          store.registerUser(
              name: _nameController.text,
              email: _emailController.text,
              password: _passwordController.text
          );
        },
        onBack: () { _pageController.previousPage(duration: Duration(milliseconds: 400), curve: Curves.easeInOut); },
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Observer(
        builder: (_) {
          if(store.loading) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text('Aguarde... salvando seu cadastro...')
              ],
            );
          }
          return _form;
        }
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final bool showsBackButton;
  final String label;
  final VoidCallback onNext;
  final VoidCallback onBack;

  _FormField({required this.controller, this.showsBackButton=true, required this.label, required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showsBackButton ?
            Container(
              padding: EdgeInsets.only(top: 40),
                child: IconButton(
                  onPressed: onBack,
                  icon: Icon(Icons.arrow_upward),
                )
              )
            : SizedBox.fromSize(size: Size.zero),
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                      label,
                      style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 60),
                      maxLines: 1
                  ),
                ),
                TextFormField(
                  controller: controller,
                  onEditingComplete: onNext,
                  style: TextStyle(
                    fontSize: 32,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none
                  ),
                )
              ],
            ),
          ),
        )

      ],
    );
  }
}