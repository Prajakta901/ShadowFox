import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wth/main.dart';

void main() {
  testWidgets('Weather app shows loading state', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
