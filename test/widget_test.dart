import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:singup_adv/main.dart';

void main() {
  testWidgets('Adventure signup smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SignupAdventureApp());

    expect(find.text('Join The Adventure!'), findsOneWidget);
  });
}
