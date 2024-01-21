import 'package:pantori/views/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('sized box', (tester) async {
    await tester.pumpWidget(MaterialApp(home: space(16, 0)));
    final Finder widget = find.byType(SizedBox);
    expect(widget, findsOneWidget);
  });

  testWidgets("text", (tester) async {
    await tester.pumpWidget(MaterialApp(home: text("foobar")));
    final Finder widget = find.byType(Text);
    expect(widget, findsOneWidget);

    final Text gen = tester.widget(widget);
    expect(gen.data, "foobar");
  });

  testWidgets("return button", (tester) async {
    BuildContext testContext;

    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (BuildContext context) {
        testContext = context;
        return returnButton(testContext, "foobar");
      }),
    ));

    final Finder widget = find.byType(TextButton);
    expect(widget, findsOneWidget);

    final Finder text =
        find.descendant(of: widget, matching: find.byType(Text));
    expect(text, findsOneWidget);

    final Text gen = tester.widget(text);
    expect(gen.data, "foobar");
  });

  testWidgets("return button", (tester) async {
    void changedDropdown(String? value) {}

    String displayDropdown(BuildContext ctx, String value) {
      return value;
    }

    BuildContext testContext;

    await tester.pumpWidget(MaterialApp(home: Scaffold(
      body: Builder(builder: (BuildContext context) {
        testContext = context;
        return dropdown(
          testContext,
          changedDropdown,
          ["foo", "bar"],
          "foo",
          displayDropdown,
        );
      }),
    )));

    final Finder widget = find.byType(DropdownButton<String>);
    expect(widget, findsOneWidget);

    final DropdownButton drop = tester.widget(widget);
    expect(drop, isA<DropdownButton<String>>());
    expect(drop.items?.length, greaterThan(1));
    expect(
        drop.items
            ?.every((DropdownMenuItem<dynamic> item) => item.value is String),
        isTrue);
    expect(drop.value, equals("foo"));
  });
}
