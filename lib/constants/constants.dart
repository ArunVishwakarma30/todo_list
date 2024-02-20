import 'package:flutter/cupertino.dart';

Color darkHeading = const Color(0xff01072f);
Color lightBg = const Color(0xfff7f5ee);
Color colorGreen = const Color(0xff40826d);

List<Color> backgroundColors = [
  const Color(0xFFCCE5FF), // light blue
  const Color(0xFFD7F9E9), // pale green
  const Color(0xFFFFF8E1), // pale yellow
  const Color(0xFFF5E6CC), // beige
  const Color(0xFFFFD6D6), // light pink
  const Color(0xFFE5E5E5), // light grey
  const Color(0xFFFFF0F0), // pale pink
  const Color(0xFFE6F9FF), // pale blue
  const Color(0xFFD4EDDA), // mint green
  const Color(0xFFFFF3CD), // pale orange
];

LinearGradient backgroundColor() {
  return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xffebdebb), Color(0xffcce6cc), Color(0xffe7f1ec)]);
}
