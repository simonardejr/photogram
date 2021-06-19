import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final String title;
  const RegisterPage({Key? key, this.title = 'Cadastre-se'}) : super(key: key);
  @override
  RegisterPageState createState() => RegisterPageState();
}
class RegisterPageState extends State<RegisterPage> {

  late PageController _pageController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: PageView(
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
            onNext: () { _pageController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.easeInOut); },
            onBack: () { _pageController.previousPage(duration: Duration(milliseconds: 400), curve: Curves.easeInOut); },
          )
        ],
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