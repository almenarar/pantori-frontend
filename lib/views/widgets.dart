import 'package:flutter/material.dart';

Widget space(double height, double width) {
  return SizedBox(
    height: height,
    width: width,
  );
}

Widget returnButton(BuildContext context, String display) {
  return ElevatedButton(
    onPressed: () {
      Navigator.pop(context);
    },
    child: regularText(display),
  );
}

Widget regularText(String content, {double size = 14}) {
  return Text(
    content,
    style: TextStyle(
      fontSize: size,
    ),
  );
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
    items: items.map<DropdownMenuItem<String>>(
      (String value) => DropdownMenuItem<String>(
        value: value,
        child: regularText(display(context, value)),
      ),
    ).toList(),
  );
}

Widget textField(TextEditingController controller, 
                 String display, 
                 Icon icon,
                 {void Function()? onTap, 
                 bool isPwd = false, 
                 int? maxLenth}) {
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
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(8)
    ),
    onPressed: onPressed, 
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, size: 12,),
        space(0, 8),
        regularText(display, size: 10),
      ],
    )
  );
}

