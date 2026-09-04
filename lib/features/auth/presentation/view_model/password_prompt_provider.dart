import 'package:flutter_riverpod/flutter_riverpod.dart';

final passwordChangePromptProvider =
    NotifierProvider<PasswordChangePromptNotifier, bool>(
      PasswordChangePromptNotifier.new,
    );

class PasswordChangePromptNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}
