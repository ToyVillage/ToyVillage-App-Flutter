import 'package:flutter_test/flutter_test.dart';

import 'package:toy_village_app/main.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    await tester.pumpWidget(const ToyVillageApp());

    expect(find.text('ToyVillage'), findsWidgets);
  });
}
