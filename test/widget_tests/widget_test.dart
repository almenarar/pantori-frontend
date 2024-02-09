import 'package:pantori/views/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('sized box', (tester) async {
    await tester.pumpWidget(MaterialApp(home: space(16, 0)));
    final Finder widget = find.byType(SizedBox);
    expect(widget, findsOneWidget);
  });

  testWidgets("regular text", (tester) async {
    await tester.pumpWidget(MaterialApp(home: regularText("foobar")));
    final Finder widget = find.byType(Text);
    expect(widget, findsOneWidget);

    final Text gen = tester.widget(widget);
    expect(gen.data, "foobar");
  });

  testWidgets("error text", (tester) async {
    await tester.pumpWidget(MaterialApp(home: errorText("foobar")));
    final Finder widget = find.byType(Text);
    expect(widget, findsOneWidget);

    final Text gen = tester.widget(widget);
    expect(gen.data, "foobar");
    expect(gen.style?.color, Colors.red);
  });

  testWidgets("local image", (tester) async {
    await tester
        .pumpWidget(MaterialApp(home: localImage("images/logo.png", 10, 10)));
    final Finder widget = find.byType(Image);
    expect(widget, findsOneWidget);

    final Image gen = tester.widget(widget);
    expect(gen.image.toString(),
        'AssetImage(bundle: null, name: "images/logo.png")');
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

  testWidgets("apply button", (tester) async {
    await tester.pumpWidget(MaterialApp(home: applyButton(() {}, "foobar")));

    final Finder widget = find.byType(ElevatedButton);
    expect(widget, findsOneWidget);

    final Finder text =
        find.descendant(of: widget, matching: find.byType(Text));
    expect(text, findsOneWidget);

    final Text gen = tester.widget(text);
    expect(gen.data, "foobar");
  });

  testWidgets("text field", (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: textField(TextEditingController(), "display",
                const Icon(Icons.access_alarm)))));

    final Finder widget = find.byType(TextField);
    expect(widget, findsOneWidget);

    final TextField gen = tester.widget(widget);
    expect(gen.decoration?.labelText, "display");
    expect(gen.obscureText, false);

    final Finder icon = find.byType(Icon);
    expect(icon, findsOneWidget);

    final Icon sub = tester.widget(icon);
    expect(sub.icon, Icons.access_alarm);
  });

  testWidgets("dropdown", (tester) async {
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
