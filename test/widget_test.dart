import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toy_village_app/main.dart';

void main() {
  testWidgets('앱이 로그인 화면으로 렌더된다', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ToyVillageApp()));
    await tester.pump();

    expect(find.text('로그인'), findsWidgets);
  });
}
