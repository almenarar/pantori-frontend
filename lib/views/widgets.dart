import 'package:flutter/material.dart';

Widget space(double height, double width) {
  return SizedBox(
    height: height,
    width: width,
  );
}

Widget returnButton(BuildContext context, String display) {
  return TextButton(
    onPressed: () {
      Navigator.pop(context);
    },
    child: text(display),
  );
}

Widget text(String content) {
  return Text(content);
}

Widget dropdown(
    BuildContext context,
    Function(String?) changed,
    List<String> items,
    String? initValue,
    String Function(BuildContext, String) display) {
  return DropdownButton<String>(
    value: initValue,
    menuMaxHeight: 250,
    onChanged: changed,
    items: items
        .map<DropdownMenuItem<String>>(
          (String value) => DropdownMenuItem<String>(
            value: value,
            child: text(display(context, value)),
          ),
        )
        .toList(),
  );
}
