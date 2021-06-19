import 'package:mobx/mobx.dart';
import 'package:photogram/app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_store.g.dart';

class OnboardingStore = _OnboardingStoreBase with _$OnboardingStore;
abstract class _OnboardingStoreBase with Store {

  SharedPreferences _sharedPreferences;

  _OnboardingStoreBase(this._sharedPreferences);

  @action
  markOnboardingAsDone() {
    _sharedPreferences.setBool(Constants.ONBOARDING_IS_DONE, true);
  }

}