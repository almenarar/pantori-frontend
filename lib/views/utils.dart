import 'package:flutter/material.dart';

bool isDarkColor(Color color) {
    double luminance = (0.2126 * color.red + 0.7152 * color.green + 0.0722 * color.blue) / 255;
    return luminance < 0.5;
  }