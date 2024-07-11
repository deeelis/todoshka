import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'localization_provider.g.dart';

@riverpod
class Localization extends _$Localization {
  @override
  String build() => 'en';

  void changeLocale() {
    state = state == 'en' ? 'ru' : 'en';
  }
}
