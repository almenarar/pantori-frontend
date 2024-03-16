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
    child: regularText(display),
  );
}

Widget regularText(String content) {
  return Text(content);
}

Widget errorText(String content) {
  return Text(
    content,
    style: const TextStyle(color: Colors.red),
  );
}

Widget dropdown(
  BuildContext context,
  Function(String?) changed,
  List<String> items,
  String? initValue,
  String Function(BuildContext, String) display,
) {
  return DropdownButton<String>(
    value: initValue,
    menuMaxHeight: 250,
    onChanged: changed,
    items: items
        .map<DropdownMenuItem<String>>(
          (String value) => DropdownMenuItem<String>(
            value: value,
            child: regularText(display(context, value)),
          ),
        )
        .toList(),
  );
}

Widget textField(TextEditingController controller, String display, Icon icon,
    {void Function()? onTap, bool isPwd = false, int? maxLenth}) {
  onTap ??= () {};
  return TextField(
      maxLength: maxLenth,
      controller: controller,
      obscureText: isPwd,
      decoration: InputDecoration(
        labelText: display,
        prefixIcon: icon,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      ),
      onTap: onTap);
}

Widget localImage(String path, double width, double height) {
  return Image.asset(path, width: width, height: height);
}

Widget applyButton(void Function() onPressed, String display) {
  return ElevatedButton(onPressed: onPressed, child: regularText(display));
}

Widget applyButtonWithIcon(void Function() onPressed, String display, IconData icon) {
  return ElevatedButton(onPressed: onPressed, child: Row(
                              children: [
                                Icon(icon, size: 15,),
                                space(0, 8),
                                regularText(display),
                              ],
                            ));
}
