import 'dart:ui';

import 'package:flutter/src/painting/text_style.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle appStyle(double fontSize, Color color, FontWeight fw) {
  return GoogleFonts.robotoSerif(
      fontSize: fontSize, color: color, fontWeight: fw);
}
