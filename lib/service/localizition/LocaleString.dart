import 'package:get/get_navigation/src/root/internacionalization.dart';

import 'base.dart';

class LocaleString extends Translations {
  //final BaseLanguage enLanguage;
  final BaseLanguage faLanguage;

  LocaleString({ required this.faLanguage});

  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    //'en_US': enLanguage.language,
    'fa_IR': faLanguage.language,
  };
}

