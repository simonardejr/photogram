import 'package:flutter_modular/flutter_modular.dart';
import 'package:photogram/app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modules/home/home_module.dart';
import 'modules/onboarding/onboarding_module.dart';
import 'modules/register/register_module.dart';
import 'modules/login/login_module.dart';

class AppModule extends Module {

  SharedPreferences _sharedPreferences;

  AppModule(this._sharedPreferences);

  @override
  List<Bind> get binds => [
    // Bind.instance(_sharedPreferences),
    Bind.singleton((i) => _sharedPreferences)
  ];

  @override
  late final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: _initialModule()),
    ModuleRoute(Constants.Routes.ONBOARDING, module: OnboardingModule()),
    ModuleRoute(Constants.Routes.REGISTER, module: RegisterModule(), transition: TransitionType.fadeIn),
    ModuleRoute(Constants.Routes.HOME, module: HomeModule()),
    ModuleRoute(Constants.Routes.LOGIN, module: LoginModule(), transition: TransitionType.fadeIn),
  ];

  Module _initialModule() {
    final onboardingDone = _sharedPreferences.getBool(Constants.ONBOARDING_IS_DONE) ?? false;
    if(onboardingDone) {
      return RegisterModule();
    }
    else {
      return OnboardingModule();
    }
  }

}