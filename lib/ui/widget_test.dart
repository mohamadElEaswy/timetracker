import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetracker/ui/widgets/global_button.dart';

void main() {
  testWidgets(
    '',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: DefaultButton(
          text: 'text',
        ),
      ));
    },
  );
}
