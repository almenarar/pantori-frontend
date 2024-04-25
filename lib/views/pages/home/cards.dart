import 'package:flutter/material.dart';

Widget cardDefaultImage({double height = 100}) {
  return Container(
    width: double.infinity,
    height: height,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10), topRight: Radius.circular(10)
      ),
      image: DecorationImage(
        image: AssetImage('images/default_card.png'),
        fit: BoxFit.fill,
      ),
    ),
  );
}

Widget cardNetworkImage(String link, {double height = 100}) {
  return Container(
    width: double.infinity,
    height: height,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10), topRight: Radius.circular(10)
      ),
      image: DecorationImage(
        image: NetworkImage(link),
        fit: BoxFit.fill,
      ),
    ),
  );
}